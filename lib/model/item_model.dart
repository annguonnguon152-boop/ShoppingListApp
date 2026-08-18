class ItemModel {
  final int? id;
  final String name;
  final int categoryId;
  final String? categoryName;
  final double estimatedPrice;
  final String? unit;
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
    this.unit,
    this.description,
    this.img = '',
    this.isFav = false,
    this.status = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category_id': categoryId,
      'estimated_price': estimatedPrice,
      'unit': unit,
      'description': description,
      'img': img,
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
      estimatedPrice: (map['estimated_price'] as num?)?.toDouble() ?? 0,
      unit: map['unit'],
      description: map['description'],
      img: map['img'] ?? '',
      isFav: map['is_fav'] == 1,
      status: map['status'] == 1,
    );
  }
}

// List<CatalogItemModel> listItem = [
//   // FOOD
//   CatalogItemModel(
//     name: 'Rice',
//     category: 'Food',
//     description: 'Rice for everyday meals and home cooking.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Bread',
//     category: 'Food',
//     description: 'Fresh bread for breakfast and sandwiches.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Eggs',
//     category: 'Food',
//     description: 'Fresh eggs for breakfast and cooking.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Chicken',
//     category: 'Food',
//     description: 'Fresh chicken for frying, grilling, and cooking.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Beef',
//     category: 'Food',
//     description: 'Fresh beef for family meals.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Fish',
//     category: 'Food',
//     description: 'Fresh fish for healthy meals.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Noodles',
//     category: 'Food',
//     description: 'Quick and convenient noodles.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Cooking Oil',
//     category: 'Food',
//     description: 'Cooking oil for frying and preparing meals.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Sugar',
//     category: 'Food',
//     description: 'Sugar for drinks, desserts, and cooking.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Salt',
//     category: 'Food',
//     description: 'Salt for seasoning and cooking.',
//     image: '',
//   ),

//   // FRUIT
//   CatalogItemModel(
//     name: 'Apple',
//     category: 'Fruit',
//     description: 'Fresh and crispy apple.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Banana',
//     category: 'Fruit',
//     description: 'Fresh ripe bananas.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Orange',
//     category: 'Fruit',
//     description: 'Fresh and juicy orange.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Mango',
//     category: 'Fruit',
//     description: 'Sweet and fresh mango.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Avocado',
//     category: 'Fruit',
//     description: 'Fresh avocado for salads and healthy meals.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Watermelon',
//     category: 'Fruit',
//     description: 'Fresh and refreshing watermelon.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Pineapple',
//     category: 'Fruit',
//     description: 'Sweet tropical pineapple.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Grapes',
//     category: 'Fruit',
//     description: 'Fresh sweet grapes.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Strawberry',
//     category: 'Fruit',
//     description: 'Fresh sweet strawberries.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Papaya',
//     category: 'Fruit',
//     description: 'Fresh ripe papaya.',
//     image: '',
//   ),

//   // VEGETABLES
//   CatalogItemModel(
//     name: 'Tomato',
//     category: 'Vegetables',
//     description: 'Fresh tomatoes for salads and cooking.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Potato',
//     category: 'Vegetables',
//     description: 'Fresh potatoes for everyday meals.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Carrot',
//     category: 'Vegetables',
//     description: 'Fresh carrots for soups and cooking.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Onion',
//     category: 'Vegetables',
//     description: 'Fresh onions for everyday cooking.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Garlic',
//     category: 'Vegetables',
//     description: 'Fresh garlic for seasoning and cooking.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Cabbage',
//     category: 'Vegetables',
//     description: 'Fresh cabbage for soups and meals.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Cucumber',
//     category: 'Vegetables',
//     description: 'Fresh cucumber for salads.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Broccoli',
//     category: 'Vegetables',
//     description: 'Fresh broccoli for healthy meals.',
//     image: '',
//   ),

//   // DRINK
//   CatalogItemModel(
//     name: 'Water',
//     category: 'Drink',
//     description: 'Bottled drinking water.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Milk',
//     category: 'Drink',
//     description: 'Fresh milk for breakfast and daily use.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Coffee',
//     category: 'Drink',
//     description: 'Coffee for hot or iced drinks.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Tea',
//     category: 'Drink',
//     description: 'Tea for hot or cold drinks.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Orange Juice',
//     category: 'Drink',
//     description: 'Refreshing orange juice.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Apple Juice',
//     category: 'Drink',
//     description: 'Sweet and refreshing apple juice.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Coca Cola',
//     category: 'Drink',
//     description: 'Refreshing carbonated soft drink.',
//     image: '',
//   ),

//   // HOUSEHOLD
//   CatalogItemModel(
//     name: 'Dish Soap',
//     category: 'HouseHold',
//     description: 'Liquid soap for washing dishes.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Laundry Detergent',
//     category: 'HouseHold',
//     description: 'Detergent for washing clothes.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Tissue',
//     category: 'HouseHold',
//     description: 'Soft household tissue paper.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Trash Bags',
//     category: 'HouseHold',
//     description: 'Trash bags for household waste.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Floor Cleaner',
//     category: 'HouseHold',
//     description: 'Cleaner for household floors.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Sponge',
//     category: 'HouseHold',
//     description: 'Sponge for dishes and cleaning.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Broom',
//     category: 'HouseHold',
//     description: 'Broom for cleaning floors.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Air Freshener',
//     category: 'HouseHold',
//     description: 'Freshens rooms and living spaces.',
//     image: '',
//   ),

//   // PERSONAL CARE
//   CatalogItemModel(
//     name: 'Shampoo',
//     category: 'Personal Care',
//     description: 'Shampoo for daily hair care.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Conditioner',
//     category: 'Personal Care',
//     description: 'Conditioner for soft and smooth hair.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Toothpaste',
//     category: 'Personal Care',
//     description: 'Toothpaste for daily oral care.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Toothbrush',
//     category: 'Personal Care',
//     description: 'Toothbrush for daily dental hygiene.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Body Wash',
//     category: 'Personal Care',
//     description: 'Body wash for daily bathing.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Face Wash',
//     category: 'Personal Care',
//     description: 'Gentle face wash for skincare.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Deodorant',
//     category: 'Personal Care',
//     description: 'Daily deodorant for personal care.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Sunscreen',
//     category: 'Personal Care',
//     description: 'Sunscreen for protection from sunlight.',
//     image: '',
//   ),

//   // CLOTHING
//   CatalogItemModel(
//     name: 'T-Shirt',
//     category: 'Clothing',
//     description: 'Casual everyday T-shirt.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Shirt',
//     category: 'Clothing',
//     description: 'Shirt for casual or formal wear.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Jeans',
//     category: 'Clothing',
//     description: 'Comfortable everyday jeans.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Shorts',
//     category: 'Clothing',
//     description: 'Comfortable casual shorts.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Jacket',
//     category: 'Clothing',
//     description: 'Jacket for cool weather.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Socks',
//     category: 'Clothing',
//     description: 'Comfortable everyday socks.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Shoes',
//     category: 'Clothing',
//     description: 'Everyday footwear.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Hat',
//     category: 'Clothing',
//     description: 'Casual hat for outdoor use.',
//     image: '',
//   ),

//   // GADGET
//   CatalogItemModel(
//     name: 'Phone Charger',
//     category: 'Gadget',
//     description: 'Charger for smartphones and mobile devices.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'USB Cable',
//     category: 'Gadget',
//     description: 'USB cable for charging and data transfer.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Power Bank',
//     category: 'Gadget',
//     description: 'Portable battery for charging devices.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Earphones',
//     category: 'Gadget',
//     description: 'Earphones for music and calls.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Headphones',
//     category: 'Gadget',
//     description: 'Headphones for music and entertainment.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Mouse',
//     category: 'Gadget',
//     description: 'Computer mouse for everyday use.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Keyboard',
//     category: 'Gadget',
//     description: 'Keyboard for computers and laptops.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Phone Case',
//     category: 'Gadget',
//     description: 'Protective case for smartphones.',
//     image: '',
//   ),

//   // OTHER
//   CatalogItemModel(
//     name: 'Notebook',
//     category: 'Other',
//     description: 'Notebook for school, work, and notes.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Pen',
//     category: 'Other',
//     description: 'Pen for writing and everyday use.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Pencil',
//     category: 'Other',
//     description: 'Pencil for school and drawing.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Umbrella',
//     category: 'Other',
//     description: 'Umbrella for rainy or sunny weather.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Gift Bag',
//     category: 'Other',
//     description: 'Gift bag for presents.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Scissors',
//     category: 'Other',
//     description: 'Scissors for home, school, and office use.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Light Bulb',
//     category: 'Other',
//     description: 'Replacement light bulb for home use.',
//     image: '',
//   ),

//   CatalogItemModel(
//     name: 'Backpack',
//     category: 'Other',
//     description: 'Backpack for school, work, or travel.',
//     image: '',
//   ),
// ];
