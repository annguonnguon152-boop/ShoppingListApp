import 'dart:io';

import 'package:flutter/material.dart';

Widget editPhotoField({
  required BuildContext context,
  required File? image,
  required VoidCallback onChange,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return Container(
    width: double.infinity,
    height: 220,
    padding: const EdgeInsets.all(6),
    decoration: BoxDecoration(
      color: isDark ? Color(0xFF242424) : Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: isDark ? Color(0xFF3A3A3A) : const Color(0xFFE4E7EC),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (image != null)
            Image.file(
              image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return editImagePlaceholder(context);
              },
            )
          else
            editImagePlaceholder(context),

          Positioned(
            right: 10,
            bottom: 10,
            child: ElevatedButton.icon(
              onPressed: onChange,
              icon: const Icon(Icons.camera_alt_outlined, size: 17),
              label: const Text(
                'Change',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 3,
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF344054),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget editImagePlaceholder(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Container(
    color: isDark ? const Color(0xFF292929) : const Color(0xFFF2F4F7),
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.image_outlined,
          size: 46,
          color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
        ),
        SizedBox(height: 8),
        Text(
          'No photo',
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
          ),
        ),
      ],
    ),
  );
}
