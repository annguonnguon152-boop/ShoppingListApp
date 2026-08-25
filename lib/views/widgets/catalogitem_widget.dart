import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/controller/item_controller.dart';
import 'package:shoppinglist_app/model/item_model.dart';

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

Widget catalogItemCard({
  required BuildContext context,
  required WidgetRef ref,
  required ItemModel item,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return Container(
    decoration: BoxDecoration(
      // CARD COLOR
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,

      borderRadius: BorderRadius.circular(20),

      // CARD BORDER
      border: Border.all(
        color: isDark ? const Color(0xFF444448) : const Color(0xFFD0D5DD),
        width: isDark ? 1.2 : 1.1,
      ),

      // CARD SHADOW
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.10),
          blurRadius: isDark ? 16 : 26,
          spreadRadius: 0,
          offset: const Offset(0, 7),
        ),

        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.08 : 0.04),
          blurRadius: 5,
          spreadRadius: 0,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),

                  child: Container(
                    width: double.infinity,
                    height: double.infinity,

                    color: isDark
                        ? const Color(0xFF292929)
                        : const Color(0xFFF2F4F7),

                    child: item.img.isNotEmpty
                        ? Image.file(
                            File(item.img),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,

                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(
                                  Icons.image_outlined,
                                  size: 38,
                                  color: isDark
                                      ? const Color(0xFF737373)
                                      : Colors.grey,
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Icon(
                              Icons.image_outlined,
                              size: 38,
                              color: isDark
                                  ? const Color(0xFF737373)
                                  : Colors.grey,
                            ),
                          ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,

                  child: InkWell(
                    onTap: () async {
                      if (item.id == null) return;

                      await ref
                          .read(itemProvider.notifier)
                          .updateFav(item.id!, !item.isFav);
                    },

                    borderRadius: BorderRadius.circular(50),

                    child: Container(
                      width: 34,
                      height: 34,

                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2C2C2E) : Colors.white,

                        shape: BoxShape.circle,

                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF48484A)
                              : const Color(0xFFEAECF0),
                          width: 1,
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: isDark ? 0.18 : 0.10,
                            ),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),

                      child: Icon(
                        item.isFav
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,

                        size: 19,

                        color: item.isFav
                            ? const Color(0xFFF04438)
                            : isDark
                            ? const Color(0xFFD0D5DD)
                            : const Color(0xFF667085),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

           SizedBox(height: 12),

          Text(
            (item.categoryName ?? 'Other').toUpperCase(),

            maxLines: 1,
            overflow: TextOverflow.ellipsis,

            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,

              color: isDark ? const Color(0xFFAAAAAA) : const Color(0xFF98A2B3),

              letterSpacing: 0.5,
            ),
          ),

           SizedBox(height: 5),
          Text(
            item.name,

            maxLines: 2,
            overflow: TextOverflow.ellipsis,

            style: TextStyle(
              fontSize: 20,
              height: 1.2,
              fontWeight: FontWeight.w700,

              color: isDark ? const Color(0xFFF5F5F5) : const Color(0xFF101828),
            ),
          ),

           SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // PRICE
              Expanded(
                child: Text(
                  '\$${item.estimatedPrice.toStringAsFixed(2)}',

                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF12B76A),
                  ),
                ),
              ),

               SizedBox(width: 8),

              InkWell(
                onTap: () {},

                borderRadius: BorderRadius.circular(50),

                child: Container(
                  width: 42,
                  height: 42,

                  decoration: BoxDecoration(
                    color: const Color(0xFF12B76A),

                    shape: BoxShape.circle,

                    boxShadow: [
                      BoxShadow(
                        color: const Color(
                          0xFF12B76A,
                        ).withValues(alpha: isDark ? 0.14 : 0.25),

                        blurRadius: isDark ? 7 : 12,
                        spreadRadius: 0,

                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: const Icon(
                    Icons.add_rounded,
                    size: 27,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

           SizedBox(height: 2),
        ],
      ),
    ),
  );
}
