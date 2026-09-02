import 'package:flutter/material.dart';
import 'package:shoppinglist_app/controller/tags_controller.dart';
import 'package:shoppinglist_app/model/tag_model.dart';

Widget itemTagChip(BuildContext context, TagModel tag) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF173D2C) : const Color(0xFFD9F2E3),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: isDark ? const Color(0xFF239B68) : const Color(0xFFC7EBD6),
        width: 1,
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          TagController.getIcon(tag.iconKey),
          size: 16,
          color: isDark ? const Color(0xFF6CE9A6) : const Color(0xFF027A48),
        ),

        SizedBox(width: 7),
        Text(
          tag.name,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isDark ? const Color(0xFF9FF2C5) : const Color(0xFF05603A),
          ),
        ),
      ],
    ),
  );
}

// unit
Widget itemUnit(BuildContext context, String unit) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return Column(
    children: [
      SizedBox(height: 24),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? const Color(0xFF343434) : const Color(0xFFE4E7EC),
          ),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.07),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF173D2C)
                    : const Color(0xFFECFDF3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                size: 20,
                color: Color(0xFF12B76A),
              ),
            ),

            SizedBox(width: 12),

            Expanded(
              child: Text(
                'Unit',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? Colors.grey.shade300
                      : const Color(0xFF475467),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF173D2C)
                    : const Color(0xFFD9F2E3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                unit,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? const Color(0xFF9FF2C5)
                      : const Color(0xFF05603A),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

//description
Widget itemDescription(BuildContext context, String description) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 25),
      Row(
        children: [
          Icon(
            Icons.notes_rounded,
            size: 21,
            color: isDark ? const Color(0xFF6CE9A6) : const Color(0xFF027A48),
          ),

          SizedBox(width: 8),

          Text(
            'Description',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
      SizedBox(height: 10),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? const Color(0xFF3F3F3F) : const Color(0xFFD0D5DD),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.12 : 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          description,
          style: TextStyle(
            fontSize: 18,
            height: 1.6,
            color: isDark ? Colors.grey.shade300 : Color(0xFF667085),
          ),
        ),
      ),
      SizedBox(height: 45),
    ],
  );
}

Widget itemDetailBottomBar({
  required BuildContext context,
  required int qty,
  required VoidCallback onDecrease,
  required VoidCallback onIncrease,
  required VoidCallback onAddToCart,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return SafeArea(
    top: false,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF181818) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF303030) : const Color(0xFFE4E7EC),
          ),
        ),
      ),
      child: Row(
        children: [
          // decrease
          InkWell(
            onTap: qty > 1 ? onDecrease : null,
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: isDark
                    ? qty > 1
                          ? const Color(0xFF343A40)
                          : const Color(0xFF25282D)
                    : qty > 1
                    ? const Color(0xFFE4E7EC)
                    : const Color(0xFFF2F4F7),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? qty > 1
                            ? const Color(0xFF475467)
                            : const Color(0xFF343A40)
                      : qty > 1
                      ? const Color(0xFFD0D5DD)
                      : const Color(0xFFE4E7EC),
                ),
              ),
              child: Icon(
                Icons.remove_rounded,
                size: 21,
                color: qty > 1
                    ? isDark
                          ? Colors.white
                          : const Color(0xFF344054)
                    : isDark
                    ? const Color(0xFF667085)
                    : const Color(0xFF98A2B3),
              ),
            ),
          ),

          SizedBox(width: 6),

          // quantity
          SizedBox(
            width: 32,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Text(
                '$qty',
                key: ValueKey(qty),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF344054),
                ),
              ),
            ),
          ),

          SizedBox(width: 6),

          // increase
          InkWell(
            onTap: onIncrease,
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF123B2A)
                    : const Color(0xFFD1FADF),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF027A48)
                      : const Color(0xFF6CE9A6),
                ),
              ),
              child: Icon(
                Icons.add_rounded,
                size: 21,
                color: isDark
                    ? const Color(0xFF6CE9A6)
                    : const Color(0xFF027A48),
              ),
            ),
          ),
          SizedBox(width: 12),
          // add to cart
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: onAddToCart,
                icon: Icon(Icons.shopping_basket_outlined, size: 19),
                label: Text(
                  'Add to Cart',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF12B76A),
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shadowColor: const Color(0xFF12B76A).withValues(alpha: 0.25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
