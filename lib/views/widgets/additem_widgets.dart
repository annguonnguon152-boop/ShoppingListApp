import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/controller/image_controller.dart';
import 'package:shoppinglist_app/controller/item_controller.dart';
import 'package:shoppinglist_app/model/category_model.dart';
import 'package:shoppinglist_app/model/item_model.dart';
import 'package:shoppinglist_app/views/itemcatalog_page.dart';

// title
Widget addItemLabel({required BuildContext context, required String title}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return Text(
    title,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: isDark
          ? Colors.grey.shade300
          : const Color.fromARGB(255, 22, 22, 22),
    ),
  );
}

Widget addItemField({
  required BuildContext context,
  required String hint,
  TextInputType? keyboardType,
  int maxLines = 1,
  String? prefixText,
  TextEditingController? controller,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return TextField(
    keyboardType: keyboardType,
    maxLines: maxLines,
    controller: controller,
    style: TextStyle(color: isDark ? Colors.white : Colors.black),
    decoration: InputDecoration(
      hintText: hint,
      prefixText: prefixText,
      hintStyle: TextStyle(
        color: isDark
            ? Colors.grey.shade500
            : const Color.fromARGB(255, 22, 22, 22),
      ),
      prefixStyle: TextStyle(
        color: isDark ? Colors.green : Colors.green,
        fontSize: 20,
      ),
      filled: true,
      fillColor: isDark ? const Color.fromARGB(255, 22, 22, 22) : Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF444444) : Color(0xFFB8C0CC),
          width: 1.5,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xFF12B76A), width: 1.5),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
    ),
  );
}

Widget addPhotoField({
  required BuildContext context,
  required VoidCallback onTap,
  required File? image,
  TransformationController? transformationController,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(14),
    child: Container(
      width: double.infinity,
      height: 230,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2420) : Color(0xFFF0F5F2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isDark ? Color(0xFF385047) : Color(0xFFC7D6CE),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: image != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  InteractiveViewer(
                    transformationController: transformationController,
                    panEnabled: true,
                    scaleEnabled: true,
                    minScale: 1.0,
                    maxScale: 3.5,
                    child: Image.file(
                      image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),

                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        shape: BoxShape.circle,
                      ),

                      child: Icon(
                        Icons.edit_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF123D2C)
                          : const Color(0xFFDDF8EC),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add_a_photo_outlined,
                      size: 25,
                      color: isDark ? Color(0xFF2DD47E) : Color(0xFF079455),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Add Product Photo',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Color(0xFF2DD47E) : Color(0xFF079455),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'High-quality images help identify items faster',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
      ),
    ),
  );
}

// button cancel + save
Widget addItemBottomButtons({
  required BuildContext context,
  required WidgetRef ref,
  required TextEditingController itemNameController,
  required TextEditingController categoryController,
  required TextEditingController priceController,
  required TextEditingController discountController,
  required TextEditingController unitController,
  required TextEditingController descriptionController,
  required List<CategoryModel> categories,
  required File? image,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return SafeArea(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF333333) : const Color(0xFFE5E7EB),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: isDark
                      ? const Color(0xFF3A3026)
                      : const Color(0xFFFFE0B2),
                  foregroundColor: isDark
                      ? const Color(0xFFFFCC80)
                      : const Color(0xFF6B3F16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  ref.read(imageProvider).clearImage();
                  discountController.clear();
                  ref.read(isOnSaleProvider.notifier).state = false;
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),

          SizedBox(width: 15),
          Expanded(
            flex: 4,
            child: SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final String itemName = itemNameController.text.trim();
                  final String categoryName = categoryController.text.trim();
                  final String priceText = priceController.text.trim();
                  final String discountText = discountController.text.trim();
                  final String unit = unitController.text.trim();
                  final String description = descriptionController.text.trim();
                  final isOnSale = ref.read(isOnSaleProvider);
                  if (itemName.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter item name')),
                    );
                    return;
                  }

                  // check category
                  if (categoryName.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select category')),
                    );
                    return;
                  }

                  int? categoryId;
                  for (final category in categories) {
                    if (category.name == categoryName) {
                      categoryId = category.id;
                      break;
                    }
                  }
                  if (categoryId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select a valid category'),
                      ),
                    );
                    return;
                  }

                  double price = 0.0;
                  if (priceText.isNotEmpty) {
                    final double? priceValue = double.tryParse(priceText);
                    if (priceValue == null || priceValue <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a valid price'),
                        ),
                      );
                      return;
                    }
                    price = priceValue;
                  }

                  double? discount;

                  if (isOnSale) {
                    if (price <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter estimated price first'),
                        ),
                      );
                      return;
                    }
                    if (discountText.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter discount percentage'),
                        ),
                      );
                      return;
                    }

                    final double? discountValue = double.tryParse(discountText);
                    if (discountValue == null ||
                        discountValue <= 0 ||
                        discountValue >= 100) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Discount must be between 1% and 99%'),
                        ),
                      );
                      return;
                    }
                    discount = discountValue;
                  }

                  final String imagePath = image?.path ?? '';
                  final ItemModel item = ItemModel(
                    name: itemName,
                    categoryId: categoryId,
                    estimatedPrice: price,
                    discount: discount,
                    unit: unit,
                    description: description,
                    img: imagePath,
                  );

                  try {
                    await ref.read(itemProvider.notifier).insertItem(item);

                    // clear controllers
                    itemNameController.clear();
                    categoryController.clear();
                    priceController.clear();
                    discountController.clear();
                    unitController.clear();
                    descriptionController.clear();

                    // clear image
                    ref.read(imageProvider).clearImage();
                    //clear on Sale
                    ref.read(isOnSaleProvider.notifier).state = false;

                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Item added successfully')),
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemcatalogPage(),
                      ),
                    );
                  } catch (e) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Cannot add item: $e')),
                    );
                  }
                },

                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Color(0xFF079455),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                icon: Icon(Icons.add_circle_outline, size: 18),
                label: Text(
                  'Save Item',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget addItemDiscount({
  required BuildContext context,
  required WidgetRef ref,
  required bool isOnSale,
  required TextEditingController discountController,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isDark ? const Color(0xFF444444) : const Color(0xFFB8C0CC),
            width: 1.5,
          ),
        ),
        child: SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'On Sale',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey.shade200 : Colors.black87,
            ),
          ),
          subtitle: Text(
            'Enable if this item has a discount',
            style: TextStyle(
              fontSize: 15,
              color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
            ),
          ),
          value: isOnSale,
          activeTrackColor: Color(0xFF12B76A),
          activeThumbColor: Colors.white,
          inactiveTrackColor: isDark ? Color(0xFF444444) : Color(0xFFDADDDC),
          inactiveThumbColor: isDark ? Colors.grey.shade300 : Colors.white,
          onChanged: (value) {
            ref.read(isOnSaleProvider.notifier).state = value;
            if (!value) {
              discountController.clear();
            }
          },
        ),
      ),
      if (isOnSale) ...[
        SizedBox(height: 18),
        addItemLabel(context: context, title: 'Discount (%)'),
        SizedBox(height: 8),
        addItemField(
          context: context,
          controller: discountController,
          hint: 'e.g. 20',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        SizedBox(height: 6),
        Text(
          'Enter 20 for a 20% discount.',
          style: TextStyle(
            fontSize: 15,
            color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
          ),
        ),
      ],
    ],
  );
}
