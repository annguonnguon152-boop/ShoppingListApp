import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CategoryModel {
  int? id;
  String name;
  String icon;

  CategoryModel({this.id, required this.name, required this.icon});

  static final Map<String, IconData> icons = {
    'food': Icons.dining_outlined,
    'fruit': Icons.eco_outlined,
    'vegetable': Icons.grass_outlined,
    'dairy': Icons.local_drink_outlined,
    'meat': Icons.kebab_dining_outlined,
    'drinks': Icons.coffee_outlined,
    'household': Icons.chair_outlined,
    'personal': Icons.spa_outlined,
    'clothing': Icons.checkroom_outlined,
    'gadget': Icons.devices_outlined,
    'pharmacy': Icons.local_pharmacy_outlined,
    'pets': Icons.pets_outlined,
    'school': Icons.book,
    'gift': Icons.card_giftcard_outlined,
    'other': Icons.category_outlined,
  };

  static final Map<String, Color> colors = {
    'food': Colors.green,
    'fruit': Colors.lightGreen,
    'vegetable': Colors.green.shade700,
    'dairy': Colors.cyan,
    'meat': Colors.redAccent,
    'drinks': Colors.blue,
    'household': Colors.orange,
    'personal': Colors.pink,
    'clothing': Colors.deepPurple,
    'gadget': Colors.indigo,
    'pharmacy': Colors.red,
    'pets': Colors.brown,
    'school': Colors.amber,
    'gift': Colors.purple,
    'other': Colors.grey,
  };

  IconData get iconData {
    return icons[icon] ?? Icons.category_outlined;
  }

  Color get colorData {
    return colors[icon] ?? Colors.grey;
  }

  // convert dart to map
  Map<String, dynamic> toMap() {
    return {"id": id, "name": name, "icon": icon};
  }

  // convert map to dart
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(id: map['id'], name: map['name'], icon: map['icon']);
  }
}
