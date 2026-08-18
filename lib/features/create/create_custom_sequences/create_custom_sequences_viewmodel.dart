import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:retro/utils/log.dart';
import 'package:tuple/tuple.dart';

typedef SequenceMetaPair = Tuple2<File, File>;

class CreateCustomSequencesViewModel extends ChangeNotifier {
  String? selectedFolderPath;
  List<Tuple2<File, File>> sequenceMetaPairs = [];
  bool isProcessing = false;

  // Content hash of each sequence file as of its last staging, so a rescan
  // of the same folder doesn't re-stage unchanged files.
  final Map<String, String> stagedHashes = {};

  void reset() {
    selectedFolderPath = null;
    sequenceMetaPairs = [];
    isProcessing = false;
    stagedHashes.clear();
  }

  /// Records the content hash of everything currently in [sequenceMetaPairs]
  /// so a subsequent rescan of the same folder won't re-stage it unchanged.
  Future<void> recordStagedHashes() async {
    for (final pair in sequenceMetaPairs) {
      final relativePath = p.relative(pair.item1.path, from: selectedFolderPath);
      stagedHashes[relativePath] =
          sha256.convert(await pair.item1.readAsBytes()).toString();
    }
  }

  Future<void> onSelectFolder() async {
    final selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
      selectedFolderPath = selectedDirectory;
      stagedHashes.clear();
      await _scanFolder();
    }
  }

  /// Re-scans the already-selected folder in place, without prompting the
  /// user to pick a folder again. Used to let the user keep iterating on
  /// files after staging instead of returning to the main screen.
  Future<void> rescanFolder() async {
    if (selectedFolderPath == null) {
      return;
    }
    await _scanFolder();
  }

  Future<void> _scanFolder() async {
    isProcessing = true;
    notifyListeners();

    sequenceMetaPairs = await compute(
      listSequenceMetaPairs,
      Tuple2(selectedFolderPath!, stagedHashes),
    );
    isProcessing = false;
    notifyListeners();
  }
}

Future<List<SequenceMetaPair>> listSequenceMetaPairs(
    Tuple2<String, Map<String, String>> params) async {
  final folderPath = params.item1;
  final stagedHashes = params.item2;
  final files = Directory(folderPath).listSync(recursive: true);
  final sequenceFiles = files.where((file) => file.path.endsWith('.seq')).toList();

  final sequenceMetaPairs = <Tuple2<File, File>>[];
  for (final sequenceFile in sequenceFiles) {
    final sequenceFileName = sequenceFile.path.split(Platform.pathSeparator).last;
    final sequenceFileNameWithoutExtension = p.basenameWithoutExtension(sequenceFileName);
    final metaFile = File(p.join(sequenceFile.parent.path, '$sequenceFileNameWithoutExtension.meta'));
    if(!metaFile.existsSync()) {
      log('Meta file not found for sequence file: $sequenceFileName! Skipping.', level: LogLevel.error);
      continue;
    }

    final relativePath = p.relative(sequenceFile.path, from: folderPath);
    final hash = sha256.convert(await (sequenceFile as File).readAsBytes()).toString();
    if (stagedHashes[relativePath] == hash) {
      // Already staged this exact content on a previous pack in this
      // session; skip it so it isn't added to the archive twice.
      continue;
    }

    sequenceMetaPairs.add(Tuple2(sequenceFile, metaFile));
  }

  return sequenceMetaPairs;
}
