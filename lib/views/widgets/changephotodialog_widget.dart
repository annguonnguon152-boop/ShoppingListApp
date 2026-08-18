import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/controller/image_controller.dart';
import 'package:shoppinglist_app/controller/user_controller.dart';

Widget changePhotoDialog({
  required BuildContext context,
  required WidgetRef ref,
}) {
  return SimpleDialog(
    title: Text(
      'Change Photo',
      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
    ),

    children: [
      // gallery
      SimpleDialogOption(
        onPressed: () async {
          await ref.read(imageProvider).getImageGallery();

          final pickedImage = ref.read(imageProvider).image;

          if (pickedImage != null) {
            ref.read(userProvider.notifier).changeImage(pickedImage.path);
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

      // camera
      SimpleDialogOption(
        onPressed: () async {
          await ref.read(imageProvider).getImageCamera();

          final pickedImage = ref.read(imageProvider).image;

          if (pickedImage != null) {
            ref.read(userProvider.notifier).changeImage(pickedImage.path);
          }

          if (context.mounted) {
            Navigator.pop(context);
          }
        },

        child: Row(
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
