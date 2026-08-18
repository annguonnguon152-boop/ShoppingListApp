import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';

class ImageController extends ChangeNotifier {
  final ImagePicker picker = ImagePicker();

  File? image;

  // Gallery
  Future<void> getImageGallery() async {
    final XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (file != null) {
      image = File(file.path);

      notifyListeners();
    }
  }

  // Camera
  Future<void> getImageCamera() async {
    final XFile? file = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (file != null) {
      image = File(file.path);

      notifyListeners();
    }
  }

  // Clear temporary image
  void clearImage() {
    image = null;

    notifyListeners();
  }
}

final imageProvider = ChangeNotifierProvider.autoDispose<ImageController>((
  ref,
) {
  return ImageController();
});
