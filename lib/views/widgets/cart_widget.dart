import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shoppinglist_app/model/item_model.dart';

Widget cartSummaryCard({
  required BuildContext context,
  required int totalItems,
  required int purchased,
  required int remaining,
  required double progress,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final cardColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;

  final borderColor = isDark
      ? const Color(0xFF3A3A3C)
      : const Color(0xFFDCE3E8);

  final titleColor = isDark ? const Color(0xFFF9FAFB) : const Color(0xFF101828);

  final labelColor = isDark ? const Color(0xFFD0D5DD) : const Color(0xFF475467);

  final progressBgColor = isDark
      ? const Color(0xFF2F3133)
      : const Color(0xFFD1FADF);

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
    decoration: BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(18),

      border: Border.all(color: borderColor, width: 1),

      boxShadow: isDark
          ? []
          : [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 18,
                spreadRadius: 1,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF123D2C)
                    : const Color(0xFFE8F8F0),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: Color(0xFF12B76A),
                size: 28,
              ),
            ),

            SizedBox(width: 14),

            Expanded(
              child: Text(
                'Total Items',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF123D2C)
                    : const Color(0xFFE8F8F0),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Text(
                '$totalItems',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF12B76A),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 22),

        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 11,
            backgroundColor: progressBgColor,
            valueColor: const AlwaysStoppedAnimation(Color(0xFF12B76A)),
          ),
        ),

        SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFF12B76A).withValues(alpha: 0.14),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle_outline,
                      size: 23,
                      color: Color(0xFF12B76A),
                    ),
                  ),

                  SizedBox(width: 10),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$purchased',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF12B76A),
                        ),
                      ),

                      SizedBox(height: 2),

                      Text(
                        'Purchased',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: labelColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Container(width: 1, height: 48, color: borderColor),

            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Color(0xFFF79009).withValues(alpha: 0.14),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.pending_actions_outlined,
                      size: 23,
                      color: Color(0xFFF79009),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$remaining',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFF79009),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Remaining',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: labelColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget cartPriceSummary({
  required BuildContext context,
  required double subTotal,
  required double discount,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Row(
    children: [
      Expanded(
        child: _priceCard(
          context: context,
          title: 'Subtotal',
          value: '\$${subTotal.toStringAsFixed(2)}',
          icon: Icons.receipt_long_outlined,
          valueColor: isDark ? Colors.white : const Color(0xFF101828),
        ),
      ),

      SizedBox(width: 12),

      Expanded(
        child: _priceCard(
          context: context,
          title: 'Discount',
          value: '-\$${discount.toStringAsFixed(2)}',
          icon: Icons.discount_outlined,
          valueColor: const Color(0xFFF79009),
        ),
      ),
    ],
  );
}

Widget _priceCard({
  required BuildContext context,
  required String title,
  required String value,
  required IconData icon,
  required Color valueColor,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isDark ? const Color(0xFF3A3A3A) : const Color(0xFFE4E7EC),
      ),
      boxShadow: isDark
          ? []
          : [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 16,
                spreadRadius: 1,
                offset: const Offset(0, 5),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isDark ? const Color(0xFF98A2B3) : const Color(0xFF667085),
            ),
            SizedBox(width: 7),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? const Color(0xFFD0D5DD)
                    : const Color(0xFF475467),
              ),
            ),
          ],
        ),

        SizedBox(height: 12),

        Text(
          value,
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: valueColor,
          ),
        ),
      ],
    ),
  );
}

Widget cartTotalEstimatedCost({
  required BuildContext context,
  required double finalPrice,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF0F3D2A) : const Color(0xFF12B76A),
      borderRadius: BorderRadius.circular(16),

      border: Border.all(
        color: isDark ? const Color(0xFF1F6A4A) : const Color(0xFF0FA968),
      ),

      boxShadow: isDark
          ? []
          : [
              BoxShadow(
                color: const Color(0xFF12B76A).withValues(alpha: 0.20),
                blurRadius: 16,
                spreadRadius: 1,
                offset: const Offset(0, 5),
              ),
            ],
    ),
    child: Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF175C40)
                : Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.payments_outlined,
            size: 24,
            color: isDark ? const Color(0xFF6CE9A6) : Colors.white,
          ),
        ),

        SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Estimated Cost',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? const Color(0xFFCFFFE5) : Colors.white,
                ),
              ),

              SizedBox(height: 2),

              Text(
                'After discount',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? const Color(0xFF9DE7BF)
                      : Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ),

        Text(
          '\$${finalPrice.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: isDark ? const Color(0xFF6CE9A6) : Colors.white,
          ),
        ),
      ],
    ),
  );
}

Widget cartItemTile({
  required BuildContext context,
  required ItemModel item,
  required int quantity,
  required bool isPurchased,
  required VoidCallback onPurchased,
  required VoidCallback onIncrement,
  required VoidCallback onDecrement,
  required VoidCallback onDelete,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  final discount = item.discount ?? 0;

  final price = discount > 0
      ? item.estimatedPrice - (item.estimatedPrice * discount / 100)
      : item.estimatedPrice;

  final normalTextColor = isDark ? Colors.white : const Color(0xFF101828);

  final purchasedTextColor = isDark
      ? Colors.grey.shade500
      : const Color(0xFF98A2B3);

  return Card(
    elevation: isDark ? 0 : 3,
    margin: const EdgeInsets.only(bottom: 12),
    color: isPurchased
        ? isDark
              ? const Color(0xFF17231D)
              : const Color(0xFFF4FBF7)
        : isDark
        ? const Color(0xFF1E1E1E)
        : Colors.white,

    shadowColor: Colors.black.withValues(alpha: 0.12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),

      side: BorderSide(
        color: isPurchased
            ? const Color(0xFF12B76A).withValues(alpha: 0.45)
            : isDark
            ? const Color(0xFF343434)
            : const Color(0xFFE4E7EC),
      ),
    ),

    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // PURCHASE BUTTON
          InkWell(
            onTap: onPurchased,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 32,
              height: 32,

              decoration: BoxDecoration(
                color: isPurchased
                    ? const Color(0xFF12B76A)
                    : isDark
                    ? const Color(0xFF292929)
                    : Colors.white,

                shape: BoxShape.circle,
                border: Border.all(
                  color: isPurchased
                      ? const Color(0xFF12B76A)
                      : isDark
                      ? const Color(0xFF667085)
                      : const Color(0xFF98A2B3),
                  width: 1.8,
                ),
              ),
              child: isPurchased
                  ? const Icon(
                      Icons.check_rounded,
                      size: 21,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
          SizedBox(width: 10),
          // IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(10),

            child: SizedBox(
              width: 68,
              height: 68,

              child: Stack(
                fit: StackFit.expand,
                children: [
                  item.img.isEmpty
                      ? Container(
                          color: isDark
                              ? const Color(0xFF292929)
                              : const Color(0xFFF2F4F7),

                          child: const Icon(
                            Icons.image_outlined,
                            color: Colors.grey,
                            size: 30,
                          ),
                        )
                      : Image.file(
                          File(item.img),
                          fit: BoxFit.cover,

                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: isDark
                                  ? const Color(0xFF292929)
                                  : const Color(0xFFF2F4F7),

                              child: const Icon(
                                Icons.broken_image_outlined,
                                color: Colors.grey,
                                size: 30,
                              ),
                            );
                          },
                        ),

                  if (isPurchased)
                    Container(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.35)
                          : Colors.white.withValues(alpha: 0.40),
                    ),
                ],
              ),
            ),
          ),

          SizedBox(width: 12),

          // NAME + UNIT + CATEGORY
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // NAME
                Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    fontSize: 17,
                    height: 1.25,
                    fontWeight: FontWeight.w700,

                    color: isPurchased ? purchasedTextColor : normalTextColor,

                    decoration: isPurchased
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,

                    decorationColor: purchasedTextColor,

                    decorationThickness: 2,
                  ),
                ),

                // UNIT
                if (item.unit != null && item.unit!.isNotEmpty) ...[
                  SizedBox(height: 4),

                  Text(
                    item.unit!,

                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,

                      color: isPurchased
                          ? purchasedTextColor
                          : isDark
                          ? Colors.grey.shade400
                          : const Color(0xFF667085),

                      decoration: isPurchased
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ],

                // CATEGORY
                if (item.categoryName != null &&
                    item.categoryName!.isNotEmpty) ...[
                  SizedBox(height: 7),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),

                    decoration: BoxDecoration(
                      color: isPurchased
                          ? isDark
                                ? const Color(0xFF28302C)
                                : const Color(0xFFECEFED)
                          : isDark
                          ? const Color(0xFF123D2C)
                          : const Color(0xFFE8F8F0),

                      borderRadius: BorderRadius.circular(6),
                    ),

                    child: Text(
                      item.categoryName!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,

                        color: isPurchased
                            ? purchasedTextColor
                            : isDark
                            ? const Color(0xFF6CE9A6)
                            : const Color(0xFF027A48),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 8),
          // PRICE + QUANTITY
          SizedBox(
            width: 100,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,

              children: [
                // PRICE
                Text(
                  '\$${price.toStringAsFixed(2)}',

                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,

                    color: isPurchased ? purchasedTextColor : normalTextColor,

                    decoration: isPurchased
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,

                    decorationColor: purchasedTextColor,

                    decorationThickness: 2,
                  ),
                ),

                const SizedBox(height: 12),

                // QUANTITY
                Row(
                  mainAxisSize: MainAxisSize.min,

                  mainAxisAlignment: MainAxisAlignment.end,

                  children: [
                    _cartQuantityButton(
                      context: context,
                      icon: Icons.remove,
                      enabled: true,
                      onTap: onDecrement,
                    ),
                    SizedBox(
                      width: 30,
                      child: Text(
                        '$quantity',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,

                          color: isDark
                              ? Colors.white
                              : const Color(0xFF344054),
                        ),
                      ),
                    ),

                    _cartQuantityButton(
                      context: context,
                      icon: Icons.add,
                      enabled: true,
                      onTap: onIncrement,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _cartQuantityButton({
  required BuildContext context,
  required IconData icon,
  required bool enabled,
  required VoidCallback onTap,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return InkWell(
    onTap: enabled ? onTap : null,
    borderRadius: BorderRadius.circular(10),

    child: Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,

      decoration: BoxDecoration(
        color: enabled
            ? isDark
                  ? const Color(0xFF123D2C)
                  : const Color(0xFFE8F8F0)
            : isDark
            ? const Color(0xFF292929)
            : const Color(0xFFF2F4F7),

        borderRadius: BorderRadius.circular(10),

        border: Border.all(
          width: 1,
          color: enabled
              ? const Color(0xFF12B76A).withValues(alpha: 0.35)
              : isDark
              ? const Color(0xFF3A3A3A)
              : const Color(0xFFE4E7EC),
        ),
      ),

      child: Icon(
        icon,
        size: 20,
        color: enabled
            ? const Color(0xFF12B76A)
            : isDark
            ? Colors.grey.shade600
            : Colors.grey.shade400,
      ),
    ),
  );
}

Widget cartBottomNavigation({
  required BuildContext context,
  required VoidCallback onComplete,
  required VoidCallback onSave,
  required VoidCallback onContinue,
  required VoidCallback onClear,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return SafeArea(
    top: false,
    child: Container(
      padding: const EdgeInsets.fromLTRB(15, 12, 15, 12),

      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF181818) : Colors.white,

        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF343434) : const Color(0xFFE4E7EC),
          ),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.08),
            blurRadius: 15,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onComplete,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xFF079455),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Complete Shopping',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),

                  SizedBox(width: 7),

                  Icon(Icons.check_circle_outline_rounded, size: 20),
                ],
              ),
            ),
          ),

          SizedBox(height: 9),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton(
              onPressed: onSave,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF027A48),
                side: const BorderSide(color: Color(0xFF12B76A)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Save to Shopping List',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),

                  SizedBox(width: 7),

                  Icon(Icons.list_alt_rounded, size: 19),
                ],
              ),
            ),
          ),

          SizedBox(height: 9),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: OutlinedButton(
                    onPressed: onContinue,

                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark
                          ? Colors.grey.shade300
                          : const Color(0xFF475467),

                      side: BorderSide(
                        color: isDark
                            ? const Color(0xFF475467)
                            : const Color(0xFFD0D5DD),
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),

                    child: Text(
                      'Continue Shopping',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 42,

                  child: TextButton.icon(
                    onPressed: onClear,

                    icon: Icon(Icons.delete_outline_rounded, size: 18),

                    label: Text(
                      'Clear Cart',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFF04438),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
