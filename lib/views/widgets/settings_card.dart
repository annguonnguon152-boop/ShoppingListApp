import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget settingTile({
  required BuildContext context,
  required IconData icon,
  required Color iconColor,
  required Color iconBackground,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
  Widget? trailing,
  Color? titleColor,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isDark
                    ? iconColor.withValues(alpha: 0.15)
                    : iconBackground,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, size: 25, color: iconColor),
            ),

            SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color:
                          titleColor ?? Theme.of(context).colorScheme.onSurface,
                    ),
                  ),

                  SizedBox(height: 5),

                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            trailing ??
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 17,
                  color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
                ),
          ],
        ),
      ),
    ),
  );
}

Widget settingSwitchTile({
  required BuildContext context,
  required IconData icon,
  required Color iconColor,
  required Color iconBackground,
  required String title,
  required String subtitle,
  required bool value,
  required ValueChanged<bool> onChanged,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
    child: Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: isDark ? iconColor.withValues(alpha: 0.15) : iconBackground,

            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: iconColor, size: 25),
        ),

        SizedBox(width: 13),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),

              SizedBox(height: 3),

              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        Switch(
          value: value,
          onChanged: onChanged,
          activeTrackColor: Color(0xFF12B76A),
          activeThumbColor: Colors.white,
          inactiveTrackColor: isDark ? Color(0xFF444444) : Color(0xFFDADDDC),
          inactiveThumbColor: isDark ? Colors.grey.shade300 : Colors.white,
        ),
      ],
    ),
  );
}

Widget settingDivider({required BuildContext context}) {
  return Padding(
    padding: const EdgeInsets.only(left: 5),
    child: Divider(
      height: 1,
      thickness: 1,
      color: Theme.of(context).colorScheme.outlineVariant,
    ),
  );
}
