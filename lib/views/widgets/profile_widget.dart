import 'package:flutter/material.dart';

Widget profileSection({
  required BuildContext context,
  required String title,
  required List<Widget> children,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: isDark ? const Color(0xFF333333) : const Color(0xFFE8EAED),
      ),
      boxShadow: isDark
          ? []
          : [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.035),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
    ),

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : const Color(0xFF344054),
          ),
        ),

        const SizedBox(height: 16),

        ...children,
      ],
    ),
  );
}

// text field
Widget profileField({
  required BuildContext context,
  required String title,
  required String value,
  required String hint,
  required IconData icon,
  required ValueChanged<String> onChanged,
  TextInputType? keyboardType,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: isDark ? Colors.grey.shade400 : const Color(0xFF667085),
        ),
      ),

      SizedBox(height: 7),

      TextFormField(
        initialValue: value,
        keyboardType: keyboardType,
        onChanged: onChanged,

        style: TextStyle(
          fontSize: 15,
          color: isDark ? Colors.white : Color(0xFF344054),
        ),

        decoration: InputDecoration(
          hintText: hint,

          hintStyle: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.grey.shade500 : Color(0xFF98A2B3),
          ),

          prefixIcon: Icon(
            icon,
            size: 18,
            color: isDark ? Colors.grey.shade300 : Color(0xFF475467),
          ),

          prefixIconConstraints: BoxConstraints(minWidth: 40, minHeight: 42),
          filled: true,
          fillColor: isDark ? Color(0xFF252525) : Colors.white,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 13),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: isDark ? Color(0xFF444444) : Color(0xFFC7CDD4),
              width: 1,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color(0xFF12B76A), width: 1.4),
          ),
        ),
      ),
    ],
  );
}
