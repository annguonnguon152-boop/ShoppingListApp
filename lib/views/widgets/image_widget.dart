import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget itemImagePlaceholder(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Container(
    color: isDark ? Color(0xFF292929) : Color(0xFFF2F4F7),
    alignment: Alignment.center,
    child: Icon(
      Icons.image_outlined,
      size: 40,
      color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
    ),
  );
}
