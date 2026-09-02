import 'package:flutter/material.dart';
import 'package:shoppinglist_app/controller/image_controller.dart';

Widget imagePickerDialog({
  required BuildContext context,
  required ImageController imageController,
  void Function(String imagePath)? onImagePicked,
}) {
  return SimpleDialog(
    title: Text(
      'Select Photo',
      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
    ),
    children: [
      // Gallery
      SimpleDialogOption(
        onPressed: () async {
          await imageController.getImageGallery();
          final pickedImage = imageController.image;
          if (pickedImage != null) {
            onImagePicked?.call(pickedImage.path);
          }
          if (context.mounted) {
            Navigator.pop(context);
          }
        },
        child: Row(
          children: [
            Icon(Icons.photo_library_outlined, color: Color(0xFF12B76A)),
            SizedBox(width: 12),
            Text('Gallery', style: TextStyle(fontSize: 15)),
          ],
        ),
      ),

      // Camera
      SimpleDialogOption(
        onPressed: () async {
          await imageController.getImageCamera();
          final pickedImage = imageController.image;
          if (pickedImage != null) {
            onImagePicked?.call(pickedImage.path);
          }
          if (context.mounted) {
            Navigator.pop(context);
          }
        },
        child: const Row(
          children: [
            Icon(Icons.camera_alt_outlined, color: Color(0xFF12B76A)),
            SizedBox(width: 12),
            Text('Camera', style: TextStyle(fontSize: 15)),
          ],
        ),
      ),
    ],
  );
}
