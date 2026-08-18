import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as dartp;
import 'package:retro/arc/arc.dart';
import 'package:retro/utils/log.dart';
import 'package:tuple/tuple.dart';

class InspectOTRViewModel extends ChangeNotifier {
  String? selectedOTRPath;
  List<String> filesInOTR = [];
  List<String> filteredFilesInOTR = [];
  bool isProcessing = false;
  bool isExtracting = false;
  int filesExtracted = 0;
  String? extractError;

  void reset() {
    selectedOTRPath = null;
    filesInOTR = [];
    filteredFilesInOTR = [];
    isProcessing = false;
    isExtracting = false;
    filesExtracted = 0;
    extractError = null;
  }

  Future<void> onSelectOTR() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['otr', 'o2r']);
    if (result != null && result.files.isNotEmpty) {
      selectedOTRPath = result.paths.first;
      if (selectedOTRPath == null) {
        // TODO: Handle this error
        return;
      }

      isProcessing = true;
      notifyListeners();
      final list = await compute(listFileItems, selectedOTRPath!);
      if (list != null) {
        filesInOTR = list;
        filteredFilesInOTR = list;
      }

      isProcessing = false;
      notifyListeners();
    }
  }

  onSearch(String query) {
    filteredFilesInOTR = filesInOTR
      .where((element) => element.toLowerCase().contains(query.toLowerCase()))
      .toList();
    notifyListeners();
  }

  Future<void> onExtractAll() async {
    if (selectedOTRPath == null || isExtracting) {
      return;
    }

    final outputDirectory = await FilePicker.platform.getDirectoryPath();
    if (outputDirectory == null) {
      return;
    }

    isExtracting = true;
    filesExtracted = 0;
    extractError = null;
    notifyListeners();

    final receivePort = ReceivePort();
    await Isolate.spawn(
      extractArchive,
      Tuple3(selectedOTRPath!, outputDirectory, receivePort.sendPort),
      onExit: receivePort.sendPort,
      onError: receivePort.sendPort,
    );

    await for (final message in receivePort) {
      if (message is int) {
        filesExtracted = filesExtracted + message;
        notifyListeners();
      } else if (message is List) {
        extractError = message.isNotEmpty ? message[0].toString() : 'Unknown error';
        log('Failed to extract archive: $extractError', level: LogLevel.error);
        break;
      } else {
        break;
      }
    }
    receivePort.close();

    isExtracting = false;
    notifyListeners();
  }
}

Future<List<String>?> listFileItems(String path) async {
  final arcFile = Arc(path);
  final files = arcFile.listItems();
  arcFile.close();
  return files;
}

Future<void> extractArchive(Tuple3<String, String, SendPort> params) async {
  final archivePath = params.item1;
  final outputDirectory = params.item2;
  final sendPort = params.item3;

  final archiveName = dartp.basenameWithoutExtension(archivePath);
  final normalizedRoot = dartp.normalize(dartp.absolute(dartp.join(outputDirectory, archiveName)));

  final arcFile = Arc(archivePath);
  await arcFile.listItems(onFile: (name, data) async {
    final relativePath = name.replaceAll(r'\', '/');
    final outputPath = dartp.normalize(dartp.join(normalizedRoot, relativePath));
    if (!dartp.equals(outputPath, normalizedRoot) && !dartp.isWithin(normalizedRoot, outputPath)) {
      log('Skipping file with unsafe path: $name', level: LogLevel.warning);
      return;
    }

    final outputFile = File(outputPath);
    await outputFile.parent.create(recursive: true);
    await outputFile.writeAsBytes(data);
    sendPort.send(1);
  });
  arcFile.close();
}
