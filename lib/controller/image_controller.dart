import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageController extends ChangeNotifier {
  final ImagePicker picker = ImagePicker();

  File? image;

  //cropping and respositioning
  Future<CroppedFile?> cropImage(String path) async {
    return await ImageCropper().cropImage(
      sourcePath: path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop & Adjust Photo',
          toolbarColor: Color(0xFF123D2C),
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          showCropGrid: true,
        ),
        IOSUiSettings(
          title: 'Crop & Adjust Photo',
          aspectRatioLockEnabled: false,
        ),
      ],
    );
  }

  // Gallery
  Future<void> getImageGallery() async {
    final XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (file != null) {
      final CroppedFile? croppedFile = await cropImage(file.path);
      if (croppedFile != null) {
        image = File(croppedFile.path);
      }
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
      final CroppedFile? croppedFile = await cropImage(file.path);
      if (croppedFile != null) {
        image = File(croppedFile.path);
      }
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
