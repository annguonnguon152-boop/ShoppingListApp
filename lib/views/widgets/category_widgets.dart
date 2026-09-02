import 'package:flutter/material.dart';
import 'package:shoppinglist_app/model/category_model.dart';

Widget categoryCard({
  required CategoryModel category,
  required int itemCount,
  VoidCallback? onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color.fromARGB(255, 172, 174, 177)),
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
              color: category.colorData.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(15),
            ),

            child: Icon(category.iconData, color: category.colorData, size: 45),
          ),

          SizedBox(height: 30),

          Text(
            category.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),

          SizedBox(height: 5),

          Text(
            '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade500),
          ),
        ],
      ),
    ),
  );
}
