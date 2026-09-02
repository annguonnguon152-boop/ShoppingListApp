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
          maxLines: 2,
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
Widget homeRecentShoppingList({
  required BuildContext context,
  required bool isDark,
  required String title,
  required String date,
  required int itemCount,
  required VoidCallback onTap,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? const Color(0xFF343434) : const Color(0xFFE4E7EC),
          ),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFF12B76A).withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                size: 21,
                color: Color(0xFF12B76A),
              ),
            ),

            SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF101828),
                    ),
                  ),

                  SizedBox(height: 3),

                  Text(
                    '$date • $itemCount ${itemCount == 1 ? 'item' : 'items'}',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? Colors.grey.shade400
                          : const Color(0xFF667085),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 8),

            Icon(
              Icons.chevron_right_rounded,
              size: 22,
              color: isDark ? Colors.grey.shade500 : const Color(0xFF98A2B3),
            ),
          ],
        ),
      ),
    ),
  );
}
