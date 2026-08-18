import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

class CreateCustomViewModel extends ChangeNotifier {
  List<File> files = [];
  String path = '';

  // Content hash of each file as of its last staging, so a rescan of the
  // same folder doesn't re-stage unchanged files.
  final Map<String, String> stagedHashes = {};

  void reset() {
    files = [];
    path = '';
    stagedHashes.clear();
  }

  /// Records the content hash of everything currently in [files] so a
  /// subsequent rescan of the same folder won't re-stage it unchanged.
  Future<void> recordStagedHashes() async {
    for (final file in files) {
      final relativePath = p.relative(file.path, from: path);
      stagedHashes[relativePath] =
          sha256.convert(await file.readAsBytes()).toString();
    }
  }

  void onSelectedFiles(List<File> files) {
    this.files = files;
    notifyListeners();
  }

  void onSelectedDirectory(String path) {
    this.path = path;
    notifyListeners();
  }

  Future<void> onSelectFiles() async {
    final selectedBaseDirectoryPath =
        await FilePicker.platform.getDirectoryPath();
    stagedHashes.clear();
    onSelectedDirectory(selectedBaseDirectoryPath ?? '');
    if (selectedBaseDirectoryPath != null) {
      await _scanFiles();
    } else {
      onSelectedFiles([]);
    }
  }

  /// Re-scans the already-selected folder in place, without prompting the
  /// user to pick a folder again. Used to let the user keep iterating on
  /// files after staging instead of returning to the main screen.
  Future<void> rescanFiles() async {
    if (path.isEmpty) {
      return;
    }
    await _scanFiles();
  }

  Future<void> _scanFiles() async {
    final directory = Directory(path);
    final dirList =
        directory.list(recursive: true).where((fsEntry) => fsEntry is File);
    final selectedFileList = <File>[];
    await for (final FileSystemEntity fsEntry in dirList) {
      if (fsEntry is File) {
        final relativePath = p.relative(fsEntry.path, from: path);
        final hash = sha256.convert(await fsEntry.readAsBytes()).toString();
        if (stagedHashes[relativePath] == hash) {
          // Already staged this exact content on a previous pack in this
          // session; skip it so it isn't added to the archive twice.
          continue;
        }
        selectedFileList.add(fsEntry);
      }
    }
    onSelectedFiles(selectedFileList);
  }
}
