import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageController extends ChangeNotifier {
  final ImagePicker picker = ImagePicker();

  File? image;

  Future<CroppedFile?> cropImage(String path) async {
    return await ImageCropper().cropImage(
      sourcePath: path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop & Adjust Photo',
          toolbarColor: const Color(0xFF123D2C),
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

  Future<File> saveImagePermanent(String path) async {
    final directory = await getApplicationDocumentsDirectory();

    final String extension = path.contains('.') ? path.split('.').last : 'jpg';

    final String fileName =
        'image_${DateTime.now().millisecondsSinceEpoch}.$extension';

    final String newPath = '${directory.path}/$fileName';

    final File newImage = await File(path).copy(newPath);

    return newImage;
  }

  Future<void> getImageGallery() async {
    final XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (file == null) {
      return;
    }

    final CroppedFile? croppedFile = await cropImage(file.path);

    if (croppedFile == null) {
      return;
    }

    image = await saveImagePermanent(croppedFile.path);

    notifyListeners();
  }

  Future<void> getImageCamera() async {
    final XFile? file = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (file == null) {
      return;
    }

    final CroppedFile? croppedFile = await cropImage(file.path);

    if (croppedFile == null) {
      return;
    }

    image = await saveImagePermanent(croppedFile.path);
    notifyListeners();
  }

  void clearImage() {
    image = null;
    notifyListeners();
  }
}

final profileImageProvider =
    ChangeNotifierProvider.autoDispose<ImageController>((ref) {
      return ImageController();
    });

final itemImageProvider = ChangeNotifierProvider.autoDispose<ImageController>((
  ref,
) {
  return ImageController();
});
