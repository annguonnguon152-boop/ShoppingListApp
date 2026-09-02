import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/controller/category_controller.dart';
import 'package:shoppinglist_app/controller/image_controller.dart';
import 'package:shoppinglist_app/controller/item_controller.dart';
import 'package:shoppinglist_app/controller/tag_action_controller.dart';
import 'package:shoppinglist_app/controller/tags_controller.dart';
import 'package:shoppinglist_app/model/item_model.dart';
import 'package:shoppinglist_app/model/tag_model.dart';
import 'package:shoppinglist_app/views/dialog/addmessage_dialog.dart';
import 'package:shoppinglist_app/views/dialog/confirm_dialog.dart';
import 'package:shoppinglist_app/views/dialog/imagepicker_dialog.dart';
import 'package:shoppinglist_app/views/widgets/additem_widgets.dart';
import 'package:shoppinglist_app/views/widgets/edititem_widgets.dart';

class ItemformPage extends ConsumerWidget {
  final ItemModel? item;

  final TextEditingController itemNameController;
  final TextEditingController priceController;
  final TextEditingController discountController;
  final TextEditingController unitController;
  final TextEditingController tagNameController;
  final TextEditingController desController;

  ItemformPage({super.key, this.item})
    : itemNameController = TextEditingController(text: item?.name ?? ''),
      priceController = TextEditingController(
        text: item == null ? '' : item.estimatedPrice.toStringAsFixed(2),
      ),
      discountController = TextEditingController(
        text: item?.discount?.toStringAsFixed(0) ?? '',
      ),
      unitController = TextEditingController(text: item?.unit ?? ''),
      tagNameController = TextEditingController(),
      desController = TextEditingController(text: item?.description ?? '');

  bool get isEdit => item != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryProvider);

    final imageController = ref.watch(itemImageProvider);
    final saleState = ref.watch(isOnSaleProvider);
    final categoryState = ref.watch(itemFormCategoryProvider);
    final tagsData = ref.watch(tagsProvider);
    final selectedTagIconKey = ref.watch(selectedTagIconProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bool isOnSale = saleState ?? item?.hasDiscount ?? false;

    final int? selectedCategoryId = categoryState ?? item?.categoryId;
    final List<TagModel> selectedTags = tagsData ?? item?.tags ?? [];
    final File? displayImage =
        imageController.image ??
        (isEdit && item!.img.isNotEmpty ? File(item!.img) : null);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Item' : 'Add Item',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Item Details',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? Colors.grey.shade300
                    : const Color.fromARGB(255, 12, 16, 20),
              ),
            ),
            SizedBox(height: 4),
            Text(
              isEdit
                  ? 'Update the information below for your item.'
                  : 'Fill in the information below to add a new item to your list.',
              style: TextStyle(
                fontSize: 15,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 20),
            addItemLabel(context: context, title: 'Item Photo'),

            SizedBox(height: 8),

            if (isEdit)
              editPhotoField(
                context: context,
                image: displayImage,
                onChange: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) {
                      return imagePickerDialog(
                        context: dialogContext,
                        imageController: ref.read(itemImageProvider),
                      );
                    },
                  );
                },
              )
            else
              addPhotoField(
                context: context,
                image: imageController.image,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) {
                      return imagePickerDialog(
                        context: dialogContext,
                        imageController: ref.read(itemImageProvider),
                      );
                    },
                  );
                },
              ),
            SizedBox(height: 20),

            addItemLabel(context: context, title: 'Item Name *'),

            SizedBox(height: 8),

            addItemField(
              context: context,
              controller: itemNameController,
              hint: 'e.g. Apple',
            ),

            SizedBox(height: 18),
            addItemLabel(context: context, title: 'Category *'),

            SizedBox(height: 8),
            categories.when(
              data: (data) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return DropdownMenu<int>(
                          width: constraints.maxWidth,
                          menuHeight: 250,
                          hintText: 'Select Category',
                          initialSelection: selectedCategoryId,
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: isDark
                                ? const Color(0xFF1E1E1E)
                                : Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: isDark
                                    ? const Color(0xFF444444)
                                    : const Color(0xFFB8C0CC),
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Color(0xFF12B76A),
                                width: 1.5,
                              ),
                            ),
                          ),
                          dropdownMenuEntries: data.map((category) {
                            return DropdownMenuEntry<int>(
                              value: category.id!,
                              label: category.name,
                            );
                          }).toList(),
                          onSelected: (value) {
                            ref.read(itemFormCategoryProvider.notifier).state =
                                value;
                          },
                        );
                      },
                    ),

                    SizedBox(height: 20),

                    addItemTags(
                      context: context,
                      tagController: tagNameController,
                      icons: TagController.tagIcons,
                      selectedIconKey: selectedTagIconKey,
                      selectedTags: selectedTags,
                      onSelected: (key) {
                        ref.read(selectedTagIconProvider.notifier).state = key;
                      },
                      onTap: () {
                        TagActionController.addTag(
                          context: context,
                          ref: ref,
                          tagNameController: tagNameController,
                          selectedTags: selectedTags,
                          selectedIconKey: selectedTagIconKey,
                        );
                      },
                      onDelete: (tag) {
                        TagActionController.removeTag(
                          ref: ref,
                          tag: tag,
                          selectedTags: selectedTags,
                        );
                      },
                    ),
                  ],
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Text('Cannot load categories'),
            ),
            SizedBox(height: 18),
            addItemLabel(context: context, title: 'Estimated Price *'),

            SizedBox(height: 8),
            addItemField(
              context: context,
              controller: priceController,
              hint: '0.00',
              prefixText: '\$ ',
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),

            SizedBox(height: 18),
            addItemDiscount(
              context: context,
              ref: ref,
              isOnSale: isOnSale,
              discountController: discountController,
            ),

            SizedBox(height: 15),
            addItemLabel(context: context, title: 'Unit'),

            SizedBox(height: 8),
            addItemField(
              context: context,
              controller: unitController,
              hint: 'e.g. kg, lb, pcs',
            ),

            SizedBox(height: 18),
            addItemLabel(context: context, title: 'Description'),

            SizedBox(height: 8),
            addItemField(
              context: context,
              controller: desController,
              hint: 'Add longer notes, brand preference, or other details...',
              maxLines: 6,
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: itemFormBottomButtons(
        context: context,
        isEdit: isEdit,
        onSave: () async {
          await _saveItem(
            context: context,
            ref: ref,
            selectedCategoryId: selectedCategoryId,
            isOnSale: isOnSale,
          );
        },
        onCancel: () {
          clearItemForm(ref);
          Navigator.pop(context);
        },
        onDelete: isEdit
            ? () async {
                await _deleteItem(context: context, ref: ref);
              }
            : null,
      ),
    );
  }

  Future<void> _saveItem({
    required BuildContext context,
    required WidgetRef ref,
    required int? selectedCategoryId,
    required bool isOnSale,
  }) async {
    final String itemName = itemNameController.text.trim();
    final String priceText = priceController.text.trim();
    final String discountText = discountController.text.trim();
    final String unit = unitController.text.trim();
    final List<TagModel> tags =
        ref.read(tagsProvider) ?? item?.tags ?? <TagModel>[];
    final String description = desController.text.trim();

    if (itemName.isEmpty) {
      showAddItemMessage(context, 'Please enter item name');
      return;
    }

    if (selectedCategoryId == null) {
      showAddItemMessage(context, 'Please select category');
      return;
    }

    if (priceText.isEmpty) {
      showAddItemMessage(context, 'Please enter estimated price');
      return;
    }

    final double? price = double.tryParse(priceText);
    if (price == null || price <= 0) {
      showAddItemMessage(context, 'Please enter a valid price');
      return;
    }

    double? discount;
    if (isOnSale) {
      if (discountText.isEmpty) {
        showAddItemMessage(context, 'Please enter discount percentage');
        return;
      }

      final double? discountValue = double.tryParse(discountText);

      if (discountValue == null || discountValue <= 0 || discountValue >= 100) {
        showAddItemMessage(context, 'Discount must be between 1% and 99%');
        return;
      }

      discount = discountValue;
    }
    final imageController = ref.read(itemImageProvider);
    final String imagePath = imageController.image?.path ?? item?.img ?? '';
    final ItemModel formItem = ItemModel(
      id: item?.id,
      name: itemName,
      categoryId: selectedCategoryId,
      estimatedPrice: price,
      discount: discount,
      unit: unit,
      tags: tags,
      description: description,
      img: imagePath,
      isFav: item?.isFav ?? false,
      status: item?.status ?? true,
    );

    try {
      if (isEdit) {
        await ref.read(itemProvider.notifier).updateItem(formItem);
      } else {
        await ref.read(itemProvider.notifier).insertItem(formItem);
      }

      if (!context.mounted) {
        return;
      }

      clearItemForm(ref);

      showAddItemMessage(
        context,
        isEdit ? 'Item updated successfully' : 'Item added successfully',
      );

      Navigator.pop(context);
    } catch (e) {
      if (!context.mounted) {
        return;
      }

      showAddItemMessage(
        context,
        isEdit ? 'Cannot update item: $e' : 'Cannot add item: $e',
      );
    }
  }

  Future<void> _deleteItem({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    if (item?.id == null) {
      return;
    }

    final bool confirm = await showConfirmDialog(
      context: context,
      title: 'Delete Item',
      message: 'Are you sure you want to delete "${item!.name}"?',
      cancelText: 'Cancel',
      confirmText: 'Delete',
      icon: Icons.delete_outline,
      confirmColor: const Color(0xFFD92D20),
    );

    if (!confirm) {
      return;
    }

    try {
      await ref.read(itemProvider.notifier).deleteItem(item!.id!);

      if (!context.mounted) {
        return;
      }

      clearItemForm(ref);

      showAddItemMessage(context, 'Item deleted successfully');

      Navigator.pop(context);
    } catch (e) {
      if (!context.mounted) {
        return;
      }

      showAddItemMessage(context, 'Cannot delete item: $e');
    }
  }
}

void clearItemForm(WidgetRef ref) {
  ref.read(itemImageProvider).clearImage();
  ref.invalidate(isOnSaleProvider);
  ref.invalidate(itemFormCategoryProvider);
  ref.invalidate(tagsProvider);
  ref.invalidate(selectedTagIconProvider);
}
