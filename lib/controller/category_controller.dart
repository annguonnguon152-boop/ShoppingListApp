import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shoppinglist_app/database/shoppingList_helper.dart';
import 'package:shoppinglist_app/model/category_model.dart';

class CategoryNotifier extends AsyncNotifier<List<CategoryModel>> {
  final ShoppinglistHelper helper = ShoppinglistHelper();

  @override
  FutureOr<List<CategoryModel>> build() async {
    loading();
    return await helper.getAllCategories();
  }

  // reload all data
  Future<void> loading() async {
    state = AsyncLoading();
    state = AsyncData(await helper.getAllCategories());
  }

  // add new data
  Future<void> insertCategory(CategoryModel category) async {
    await helper.insertCategory(category);
    loading();
    state = AsyncData(await helper.getAllCategories());
  }

  // search
  Future<void> searchCategory(String search) async {
    if (search.trim().isEmpty) {
      state = AsyncData(await helper.getAllCategories());
      return;
    }
    state = AsyncData(await helper.searchCategory(search.trim()));
  }
}

final categoryProvider =
    AsyncNotifierProvider<CategoryNotifier, List<CategoryModel>>(
      CategoryNotifier.new,
    );

//select category
final selectedCategoryProvider = StateProvider<int?>((ref) => null);

final categoryIconProvider = Provider.family<IconData, int>((ref, categoryId) {
  final categories = ref.watch(categoryProvider);

  return categories.maybeWhen(
    data: (data) {
      for (final category in data) {
        if (category.id == categoryId) {
          return category.iconData;
        }
      }

      return Icons.category_outlined;
    },
    orElse: () => Icons.category_outlined,
  );
});
