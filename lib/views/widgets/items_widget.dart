import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/controller/cart_controller.dart';
import 'package:shoppinglist_app/controller/item_controller.dart';
import 'package:shoppinglist_app/model/item_model.dart';
import 'package:shoppinglist_app/views/itemdetail_page.dart';
import 'package:shoppinglist_app/views/widgets/image_widget.dart';

Widget categoryItem({
  required BuildContext context,
  required IconData icon,
  required String name,
  required bool selected,
  required VoidCallback onTap,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(14),
    child: Container(
      width: 75,
      margin: EdgeInsets.only(right: 6),
      child: Column(
        children: [
          Container(
            width: 65,
            height: 65,

            decoration: BoxDecoration(
              color: selected
                  ? Color(0xFF12B76A)
                  : isDark
                  ? Color(0xFF1E1E1E)
                  : Colors.white,

              borderRadius: BorderRadius.circular(14),

              border: Border.all(
                color: selected
                    ? Color(0xFF12B76A)
                    : isDark
                    ? Color(0xFF343434)
                    : Color(0xFFE5E9EE),
              ),
            ),

            child: Icon(
              icon,
              size: 30,

              color: selected
                  ? Colors.white
                  : isDark
                  ? Colors.grey.shade400
                  : const Color(0xFF344054),
            ),
          ),
          SizedBox(height: 6),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w400,

              color: selected ? const Color(0xFF12B76A) : null,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget itemCard({
  required BuildContext context,
  required WidgetRef ref,
  required ItemModel item,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ItemdetailPage(item: item)),
      );
    },
    child: Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF343434) : const Color(0xFFE4E7EC),
        ),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.035),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: Stack(
              fit: StackFit.expand,
              children: [
                item.img.isNotEmpty
                    ? Image.file(
                        File(item.img),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return itemImagePlaceholder(context);
                        },
                      )
                    : itemImagePlaceholder(context),

                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6CE9A6),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      (item.categoryName ?? 'Other').toUpperCase(),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF027A48),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 7,
                  right: 7,
                  child: InkWell(
                    onTap: () async {
                      if (item.id == null) return;

                      await ref
                          .read(itemProvider.notifier)
                          .updateFav(item.id!, !item.isFav);
                    },
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        item.isFav ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color: item.isFav
                            ? const Color(0xFFF04438)
                            : const Color(0xFF667085),
                      ),
                    ),
                  ),
                ),

                if (item.hasDiscount)
                  Positioned(
                    left: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF04438),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        '-${item.discount!.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 9, 9, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF101828),
                    ),
                  ),

                  SizedBox(height: 5),
                  if (item.hasDiscount)
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Est. \$${item.finalPrice.toStringAsFixed(2)}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF079455),
                            ),
                          ),
                        ),

                        SizedBox(width: 5),

                        Text(
                          '\$${item.estimatedPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF98A2B3),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      'Est. \$${item.estimatedPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? Colors.grey.shade400
                            : Color(0xFF079455),
                      ),
                    ),

                  Spacer(),

                  Align(
                    alignment: Alignment.bottomRight,
                    child: Tooltip(
                      message: 'Add to cart',
                      child: Material(
                        color: Colors.transparent,

                        child: InkWell(
                          onTap: () {
                            ref.read(cartProvider.notifier).addToCart(item, 1);
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 35,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF12B76A),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF12B76A,
                                  ).withValues(alpha: 0.28),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_shopping_cart_outlined,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Add',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
