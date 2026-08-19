import 'dart:io';

import 'package:flutter/material.dart';

// title
Widget addItemLabel({required BuildContext context, required String title}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return Text(
    title,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: isDark
          ? Colors.grey.shade300
          : const Color.fromARGB(255, 22, 22, 22),
    ),
  );
}

Widget addItemField({
  required BuildContext context,
  required String hint,
  TextInputType? keyboardType,
  int maxLines = 1,
  String? prefixText,
  ValueChanged<String>? onChanged,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return TextField(
    keyboardType: keyboardType,
    maxLines: maxLines,
    onChanged: onChanged,
    style: TextStyle(color: isDark ? Colors.white : Colors.black),
    decoration: InputDecoration(
      hintText: hint,
      prefixText: prefixText,
      hintStyle: TextStyle(
        color: isDark
            ? Colors.grey.shade500
            : const Color.fromARGB(255, 22, 22, 22),
      ),
      prefixStyle: TextStyle(
        color: isDark ? Colors.green : Colors.green,
        fontSize: 20,
      ),
      filled: true,
      fillColor: isDark ? const Color.fromARGB(255, 22, 22, 22) : Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF444444) : Color(0xFFB8C0CC),
          width: 1.2,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xFF12B76A), width: 1.5),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
    ),
  );
}

Widget addPhotoField({
  required BuildContext context,
  required VoidCallback onTap,
  required File? image,
  TransformationController? transformationController,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(14),
    child: Container(
      width: double.infinity,
      height: 230,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2420) : Color(0xFFF0F5F2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isDark ? Color(0xFF385047) : Color(0xFFC7D6CE),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: image != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  InteractiveViewer(
                    transformationController: transformationController,
                    panEnabled: true,
                    scaleEnabled: true,
                    minScale: 1.0,
                    maxScale: 3.5,
                    child: Image.file(
                      image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),

                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        shape: BoxShape.circle,
                      ),

                      child: Icon(
                        Icons.edit_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF123D2C)
                          : const Color(0xFFDDF8EC),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add_a_photo_outlined,
                      size: 25,
                      color: isDark
                          ? const Color(0xFF2DD47E)
                          : const Color(0xFF079455),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Add Product Photo',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? const Color(0xFF2DD47E)
                          : const Color(0xFF079455),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'High-quality images help identify items faster',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
      ),
    ),
  );
}
