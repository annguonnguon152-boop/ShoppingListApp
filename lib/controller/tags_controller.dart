import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shoppinglist_app/database/shoppingList_helper.dart';
import 'package:shoppinglist_app/model/tag_model.dart';

class TagController {
  static final Map<String, IconData> tagIcons = {
    'eco': Icons.eco_outlined,
    'fresh': Icons.energy_savings_leaf_outlined,
    'verified': Icons.verified_outlined,
    'health': Icons.health_and_safety_outlined,
    'fitness': Icons.fitness_center_outlined,

    'water': Icons.water_drop_outlined,
    'coffee': Icons.coffee_outlined,

    'clean': Icons.cleaning_services_outlined,
    'recycle': Icons.recycling_outlined,
    'durable': Icons.shield_outlined,

    'clothing': Icons.checkroom_outlined,
    'washable': Icons.local_laundry_service_outlined,

    'device': Icons.devices_outlined,
    'wireless': Icons.wifi_outlined,
    'bluetooth': Icons.bluetooth_outlined,
    'battery': Icons.battery_charging_full_outlined,
    'charging': Icons.bolt_outlined,

    'medicine': Icons.medication_outlined,
    'first_aid': Icons.medical_services_outlined,

    'pets': Icons.pets_outlined,

    'school': Icons.school_outlined,
    'book': Icons.menu_book_outlined,
    'write': Icons.edit_outlined,

    'gift': Icons.card_giftcard_outlined,
    'birthday': Icons.cake_outlined,

    'star': Icons.star_outline_rounded,
    'premium': Icons.workspace_premium_outlined,
    'other': Icons.sell_outlined,
  };

  static IconData getIcon(String iconKey) {
    return tagIcons[iconKey] ?? Icons.sell_outlined;
  }
}

final tagsProvider = StateProvider.autoDispose<List<TagModel>?>((ref) => null);

final selectedTagIconProvider = StateProvider.autoDispose<String?>(
  (ref) => null,
);

final itemTagsProvider = FutureProvider<List<String>>((ref) async {
  final helper = ShoppinglistHelper();
  return await helper.getAllItemTags();
});
