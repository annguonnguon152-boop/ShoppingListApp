import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shoppinglist_app/controller/item_controller.dart';
import 'package:shoppinglist_app/model/item_model.dart';

// favourite filter
final favoriteFilterProvider = StateProvider.autoDispose<String>(
  (ref) => 'All',
);

// favourite item
final favoriteItemsProvider = Provider.autoDispose<AsyncValue<List<ItemModel>>>(
  (ref) {
    final itemsAsync = ref.watch(itemProvider);
    final filter = ref.watch(favoriteFilterProvider);

    return itemsAsync.whenData((items) {
      // Only favorite items
      var favorites = items.where((item) => item.isFav).toList();

      // On Sale
      if (filter == 'On Sale') {
        favorites = favorites
            .where((item) => item.discount != null && item.discount! > 0)
            .toList();
      }

      // Low Price
      if (filter == 'Low Price') {
        favorites.sort((a, b) => a.finalPrice.compareTo(b.finalPrice));
      }

      // High Price
      if (filter == 'High Price') {
        favorites.sort((a, b) => b.finalPrice.compareTo(a.finalPrice));
      }

      return favorites;
    });
  },
);
