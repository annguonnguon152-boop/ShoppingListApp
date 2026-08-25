import 'package:flutter/material.dart';

Widget homeStatCard({
  required BuildContext context,
  required IconData icon,
  required String title,
  required String value,
  required Color iconColor,
  required Color iconBg,
  Color? valueColor,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Container(
    height: 150,
    margin: const EdgeInsets.all(3),
    padding: const EdgeInsets.all(16),

    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(20),

      border: Border.all(
        color: isDark
            ? Colors.white.withValues(alpha: 0.07)
            : Colors.grey.withValues(alpha: 0.12),
      ),

      boxShadow: isDark
          ? [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 16,
                offset: const Offset(0, 5),
              ),
            ]
          : [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 20,
                spreadRadius: 1,
                offset: const Offset(0, 7),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
    ),

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ICON
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isDark ? iconColor.withValues(alpha: 0.15) : iconBg,
            borderRadius: BorderRadius.circular(13),
          ),

          child: Icon(icon, color: iconColor, size: 24),
        ),

        Spacer(),

        Text(
          title.toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,

          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.7,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),

        SizedBox(height: 8),

        // VALUE
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 27,
            height: 1,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            color: valueColor ?? Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    ),
  );
}

// Widget monthlyBudgetCard({
//   required BuildContext context,
//   required String amount,
//   required String limit,
//   required double progress,
// }) {
//   final isDark = Theme.of(context).brightness == Brightness.dark;
//   final 
//   return
// }
