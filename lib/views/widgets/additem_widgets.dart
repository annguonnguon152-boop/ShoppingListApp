import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/controller/item_controller.dart';
import 'package:shoppinglist_app/controller/tags_controller.dart';
import 'package:shoppinglist_app/model/tag_model.dart';

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
      prefixStyle: const TextStyle(color: Colors.green, fontSize: 20),
      filled: true,
      fillColor: isDark ? const Color.fromARGB(255, 22, 22, 22) : Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF444444) : const Color(0xFFB8C0CC),
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF12B76A), width: 1.5),
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
        color: isDark ? const Color(0xFF1A2420) : const Color(0xFFF0F5F2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isDark ? const Color(0xFF385047) : const Color(0xFFC7D6CE),
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
                      color: isDark
                          ? const Color(0xFF2DD47E)
                          : const Color(0xFF079455),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Add Item Photo',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? const Color(0xFF2DD47E)
                          : const Color(0xFF079455),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'High-quality images help identify items faster',
                    textAlign: TextAlign.center,
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

Widget itemFormBottomButtons({
  required BuildContext context,
  required bool isEdit,
  required Future<void> Function() onSave,
  required VoidCallback onCancel,
  Future<void> Function()? onDelete,
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
      child: isEdit
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await onSave();
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFF079455),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    icon: Icon(Icons.save_outlined, size: 18),
                    label: Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: onCancel,
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
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: onDelete == null
                              ? null
                              : () async {
                                  await onDelete();
                                },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: isDark
                                ? const Color(0xFF3D2327)
                                : const Color(0xFFFCE8EB),
                            foregroundColor: const Color(0xFFD92D20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          icon: Icon(Icons.delete_outline, size: 18),
                          label: Text(
                            'Delete',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: onCancel,
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
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
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
                        await onSave();
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xFF079455),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      icon: const Icon(Icons.add_circle_outline, size: 18),
                      label: const Text(
                        'Save Item',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
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
        const SizedBox(height: 18),
        addItemLabel(context: context, title: 'Discount (%)'),
        const SizedBox(height: 8),
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

Widget addItemTags({
  required BuildContext context,
  required TextEditingController tagController,
  required Map<String, IconData> icons,
  required String? selectedIconKey,
  required List<TagModel> selectedTags,
  required void Function(String key) onSelected,
  required VoidCallback onTap,
  required void Function(TagModel tag) onDelete,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      addItemLabel(context: context, title: 'Tags'),

      SizedBox(height: 5),

      Text(
        'Enter a tag name and choose an icon',
        style: TextStyle(
          fontSize: 15,
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
        ),
      ),

      SizedBox(height: 10),

      addItemField(
        context: context,
        controller: tagController,
        hint: 'e.g. Organic, Cotton, Wireless',
      ),

      SizedBox(height: 12),

      addItemLabel(context: context, title: 'Choose Icons'),

      SizedBox(height: 10),

      Wrap(
        spacing: 9,
        runSpacing: 9,
        children: icons.entries.map((entry) {
          final isSelected = selectedIconKey == entry.key;

          final isUsed = selectedTags.any((tag) => tag.iconKey == entry.key);

          return InkWell(
            onTap: isUsed
                ? null
                : () {
                    onSelected(entry.key);
                  },
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF12B76A)
                    : isUsed
                    ? isDark
                          ? const Color(0xFF1D3329)
                          : const Color(0xFFECFDF3)
                    : isDark
                    ? const Color(0xFF1E1E1E)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF6CE9A6)
                      : isUsed
                      ? const Color(0xFF12B76A)
                      : isDark
                      ? const Color(0xFF444444)
                      : const Color(0xFFB8C0CC),
                  width: isSelected || isUsed ? 1.5 : 1,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    entry.value,
                    size: 21,
                    color: isSelected
                        ? Colors.white
                        : isUsed
                        ? const Color(0xFF12B76A)
                        : isDark
                        ? Colors.grey.shade300
                        : const Color(0xFF667085),
                  ),

                  if (isUsed)
                    const Positioned(
                      right: 3,
                      top: 3,
                      child: Icon(
                        Icons.check_circle,
                        size: 12,
                        color: Color(0xFF12B76A),
                      ),
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),

      SizedBox(height: 15),
      SizedBox(
        width: double.infinity,
        height: 46,
        child: ElevatedButton.icon(
          onPressed: onTap,
          icon: Icon(Icons.add_rounded, size: 20),
          label: Text('Add Tag', style: TextStyle(fontWeight: FontWeight.w600)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF12B76A),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),

      if (selectedTags.isNotEmpty) ...[
        SizedBox(height: 15),
        Text(
          'Added Tags',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.grey.shade300 : const Color(0xFF344054),
          ),
        ),

        SizedBox(height: 8),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: selectedTags.map((tag) {
            return Chip(
              avatar: Icon(
                TagController.getIcon(tag.iconKey),
                size: 16,
                color: const Color(0xFF027A48),
              ),

              label: Text(tag.name),

              deleteIcon: const Icon(Icons.close_rounded, size: 17),

              onDeleted: () {
                onDelete(tag);
              },

              backgroundColor: isDark
                  ? const Color(0xFF1D3329)
                  : const Color(0xFFECFDF3),

              side: BorderSide(
                color: isDark
                    ? const Color(0xFF027A48)
                    : const Color(0xFFA6F4C5),
              ),

              labelStyle: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? const Color(0xFF6CE9A6)
                    : const Color(0xFF027A48),
              ),
            );
          }).toList(),
        ),
      ],
    ],
  );
}
