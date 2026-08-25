import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/controller/category_controller.dart';
import 'package:shoppinglist_app/controller/image_controller.dart';
import 'package:shoppinglist_app/controller/item_controller.dart';
import 'package:shoppinglist_app/views/widgets/additem_widgets.dart';
import 'package:shoppinglist_app/views/widgets/changephotodialog_widget.dart';

class AdditemPage extends ConsumerWidget {
  AdditemPage({super.key});
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController desController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryProvider);
    final imageController = ref.watch(imageProvider);
    final isOnSale = ref.watch(isOnSaleProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Item',
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
              'Fill in the information below to add a new item to your list.',
              style: TextStyle(
                fontSize: 15,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 20),

            addItemLabel(context: context, title: 'Add Photo'),

            SizedBox(height: 8),

            addPhotoField(
              context: context,
              image: imageController.image,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) {
                    return changePhotoDialog(context: dialogContext, ref: ref);
                  },
                );
              },
            ),

            SizedBox(height: 20),
            addItemLabel(context: context, title: 'Item Name'),

            SizedBox(height: 8),
            addItemField(
              context: context,
              controller: itemNameController,
              hint: 'e.g. Apple',
            ),

            SizedBox(height: 18),
            addItemLabel(context: context, title: 'Category'),
            SizedBox(height: 8),

            categories.when(
              data: (data) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return DropdownMenu<int>(
                      controller: categoryController,
                      width: constraints.maxWidth,
                      menuHeight: 250,
                      hintText: 'Select Category',

                      inputDecorationTheme: InputDecorationTheme(
                        filled: true,

                        fillColor: isDark
                            ? const Color(0xFF1E1E1E)
                            : Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDark
                                ? const Color(0xFF3A3A3A)
                                : const Color(0xFFC7CDD4),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
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

                      onSelected: (value) {},
                    );
                  },
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) =>
                  const Text('Cannot load categories'),
            ),
            SizedBox(height: 18),

            addItemLabel(context: context, title: 'Estimated Price'),

            SizedBox(height: 8),

            addItemField(
              context: context,
              controller: priceController,
              hint: '0.00',
              prefixText: '\$ ',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
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
      bottomNavigationBar: categories.when(
        data: (data) {
          return addItemBottomButtons(
            context: context,
            ref: ref,
            itemNameController: itemNameController,
            categoryController: categoryController,
            priceController: priceController,
            discountController: discountController,
            unitController: unitController,
            descriptionController: desController,
            categories: data,
            image: imageController.image,
          );
        },
        loading: () {
          return SizedBox();
        },
        error: (error, stackTrace) {
          return const SizedBox();
        },
      ),
    );
  }
}
