import 'package:shoppinglist_app/model/item_model.dart';

class CartModel {
  final ItemModel item;
  final int quantity;
  final bool isPurchased;

  const CartModel({
    required this.item,
    this.quantity = 1,
    this.isPurchased = false,
  });

  CartModel copyWith({
    ItemModel? item,
    int? quantity,
    bool? isPurchased,
  }) {
    return CartModel(
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
      isPurchased: isPurchased ?? this.isPurchased,
    );
  }
}