import 'package:flutter/material.dart';
import 'package:shoppinglist_app/model/category_model.dart';

Map<String, IconData> categoryIcons = {
  'food': Icons.dining_outlined,
  'fruit': Icons.eco_outlined,
  'vegetable': Icons.grass_outlined,
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

Map<String, Color> categoryColors = {
  'food': Colors.green,
  'fruit': Colors.lightGreen,
  'vegetable': Colors.green.shade700,
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

Widget categoryCard({required CategoryModel category, int itemCount = 0}) {
  final icon = categoryIcons[category.icon] ?? Icons.category_outlined;
  final color = categoryColors[category.icon] ?? Colors.grey;
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),

      border: Border.all(color: Color.fromARGB(255, 172, 174, 177)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.03),
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 30),
        Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(15),
          ),

          child: Icon(icon, color: color, size: 45),
        ),
        SizedBox(height: 30),

        Text(
          category.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),

        SizedBox(height: 5),

        Text(
          '$itemCount items',
          style: TextStyle(fontSize: 18, color: Colors.grey.shade500),
        ),
      ],
    ),
  );
}
