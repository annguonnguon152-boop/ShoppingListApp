import 'dart:convert';
import 'package:shoppinglist_app/model/tag_model.dart';

class ItemModel {
  final int? id;
  final String name;
  final int categoryId;
  final String? categoryName;
  final double estimatedPrice;
  final double? discount;
  final String? unit;
  final List<TagModel> tags;
  final String? description;
  final String img;
  final bool isFav;
  final bool status;

  const ItemModel({
    this.id,
    required this.name,
    required this.categoryId,
    this.categoryName,
    this.estimatedPrice = 0,
    this.discount,
    this.unit,
    this.tags = const [],
    this.description,
    this.img = '',
    this.isFav = false,
    this.status = true,
  });

  bool get hasDiscount {
    return discount != null &&
        discount! > 0 &&
        discount! < 100 &&
        estimatedPrice > 0;
  }

  // amount
  double get discountAmount {
    return hasDiscount ? estimatedPrice * discount! / 100 : 0;
  }

  // after discount
  double get finalPrice {
    return estimatedPrice - discountAmount;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category_id': categoryId,
      'estimate_price': estimatedPrice,
      'discount': discount,
      'unit': unit,
      'tags': jsonEncode(tags.map((e) => e.toMap()).toList()),
      'description': description,
      'image': img,
      'is_fav': isFav ? 1 : 0,
      'status': status ? 1 : 0,
    };
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'],
      name: map['name'],
      categoryId: map['category_id'],
      categoryName: map['category_name'],
      estimatedPrice: (map['estimate_price'] as num?)?.toDouble() ?? 0,
      discount: (map['discount'] as num?)?.toDouble(),
      unit: map['unit'],
      tags: _parseTags(map['tags']),
      description: map['description'],
      img: map['image'] ?? '',
      isFav: map['is_fav'] == 1,
      status: map['status'] == 1,
    );
  }
  static List<TagModel> _parseTags(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(value.toString());

      if (decoded is List) {
        return decoded
            .map((tag) => TagModel.fromMap(Map<String, dynamic>.from(tag)))
            .toList();
      }

      return [];
    } catch (e) {
      return [];
    }
  }
}
