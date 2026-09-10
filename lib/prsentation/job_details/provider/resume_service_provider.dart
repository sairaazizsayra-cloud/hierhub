import 'dart:typed_data';

import 'package:flutter/material.dart';

class ResumeProvider extends ChangeNotifier {
  bool isUploading = false;
  String? resumeUrl;

  final dynamic datasource;

  ResumeProvider({required this.datasource});

  Future<String> uploadResume({
    required String fileName,
    Uint8List? bytes,
    String? filePath,
  }) async {
    isUploading = true;
    notifyListeners();
    try {
      final String? uploadedUrl = await datasource.uploadResume(
        fileName: fileName,
        bytes: bytes,
        filePath: filePath,
      );
      if (uploadedUrl == null) {
        throw Exception('Failed to upload resume');
      }
      resumeUrl = uploadedUrl;
      return uploadedUrl;
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }
}
