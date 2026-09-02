import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/controller/cart_controller.dart';
import 'package:shoppinglist_app/controller/category_controller.dart';
import 'package:shoppinglist_app/controller/item_controller.dart';
import 'package:shoppinglist_app/controller/quantity_controller.dart';
import 'package:shoppinglist_app/model/item_model.dart';
import 'package:shoppinglist_app/views/itemform_page.dart';
import 'package:shoppinglist_app/views/widgets/itemdetail_widgets.dart';

class ItemdetailPage extends ConsumerWidget {
  final ItemModel item;
  const ItemdetailPage({super.key, required this.item});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final itemsAsync = ref.watch(itemProvider);
    final currentItem = item.id == null
        ? item
        : ref.watch(itemDetailProvider(item.id!)) ?? item;
    int quantity = ref.watch(quantityProvider);
    final isFav = ref.watch(itemDetailFavProvider(currentItem));
    final categoryIcon = ref.watch(
      categoryIconProvider(currentItem.categoryId),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Details'),
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ItemformPage(item: currentItem);
                  },
                ),
              );
            },
            icon: Icon(Icons.edit_outlined),
          ),
          IconButton(
            onPressed: () async {
              if (currentItem.id != null) {
                final newFav = !isFav;
                ref.read(itemDetailFavProvider(currentItem).notifier).state =
                    newFav;
                await ref
                    .read(itemProvider.notifier)
                    .updateFav(currentItem.id!, newFav);
              }
            },
            icon: Icon(
              isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            ),
            iconSize: 23,
            color: isFav
                ? const Color(0xFFF04438)
                : isDark
                ? Colors.grey.shade300
                : const Color(0xFF475467),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 320,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF292929)
                        : const Color(0xFFF2F4F7),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(35),
                      bottomLeft: Radius.circular(35),
                    ),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF3A3A3A)
                          : const Color(0xFFE4E7EC),
                    ),
                  ),
                  child: currentItem.img.isNotEmpty
                      ? Image.file(
                          File(currentItem.img),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.image_outlined,
                                size: 70,
                                color: isDark
                                    ? Colors.grey.shade600
                                    : Colors.grey.shade400,
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Icon(
                            Icons.image_outlined,
                            size: 70,
                            color: isDark
                                ? Colors.grey.shade600
                                : Colors.grey.shade400,
                          ),
                        ),
                ),
                Positioned(
                  top: 12,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6CE9A6),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.10),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          categoryIcon,
                          size: 17,
                          color: const Color(0xFF027A48),
                        ),
                        SizedBox(width: 6),
                        Text(
                          (currentItem.categoryName ?? 'Other').toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            color: Color(0xFF027A48),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (currentItem.hasDiscount)
                  Positioned(
                    left: 14,
                    bottom: 14,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFF04438,
                            ).withValues(alpha: 0.82),

                            borderRadius: BorderRadius.circular(20),

                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.35),
                              width: 1,
                            ),

                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFF04438,
                                ).withValues(alpha: 0.28),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),

                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.local_offer_rounded,
                                size: 15,
                                color: Colors.white,
                              ),
                              SizedBox(width: 5),
                              Text(
                                '-${currentItem.discount!.toStringAsFixed(0)}%',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.3,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentItem.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 25,
                      height: 1.2,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 15),
                  if (currentItem.hasDiscount)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Est. \$${currentItem.finalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF079455),
                          ),
                        ),

                        SizedBox(width: 10),
                        Text(
                          '\$${currentItem.estimatedPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF98A2B3),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      'Est. \$${currentItem.estimatedPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF079455),
                      ),
                    ),

                  if (currentItem.tags.isNotEmpty) ...[
                    SizedBox(height: 20),
                    Wrap(
                      spacing: 8,
                      runSpacing: 10,
                      children: currentItem.tags.map((tag) {
                        return itemTagChip(context, tag);
                      }).toList(),
                    ),
                  ],
                  if (currentItem.unit != null &&
                      currentItem.unit!.trim().isNotEmpty)
                    itemUnit(context, currentItem.unit!),
                  if (currentItem.description != null &&
                      currentItem.description!.trim().isNotEmpty)
                    itemDescription(context, currentItem.description!),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: itemDetailBottomBar(
        context: context,
        qty: quantity,
        onDecrease: () {
          ref.read(quantityProvider.notifier).decrement();
        },
        onIncrease: () {
          ref.read(quantityProvider.notifier).increment();
        },
        onAddToCart: () {
          ref.read(cartProvider.notifier).addToCart(currentItem, quantity);
          ref.read(quantityProvider.notifier).reset();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${currentItem.name} added to cart.')),
          );
        },
      ),
    );
  }
}
