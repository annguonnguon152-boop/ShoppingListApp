import 'package:shoppinglist_app/model/item_model.dart';

class ShoppingListDetailModel {
  final int? id;
  final int listId;
  final int itemId;
  final ItemModel item;
  final int quantity;
  final bool isPurchased;

  const ShoppingListDetailModel({
    this.id,
    required this.listId,
    required this.itemId,
    required this.item,
    this.quantity = 1,
    this.isPurchased = false,
  });

  // total price of each item row
  double get lineTotal {
    return item.finalPrice * quantity;
  }

  factory ShoppingListDetailModel.fromMap(Map<String, dynamic> map) {
    return ShoppingListDetailModel(
      id: map['detail_id'] as int?,
      listId: map['list_id'] as int,
      itemId: map['item_id'] as int,
      item: ItemModel.fromMap(map),
      quantity: map['quantity'] as int? ?? 1,
      isPurchased: map['is_purchased'] == 1,
    );
  }
}
