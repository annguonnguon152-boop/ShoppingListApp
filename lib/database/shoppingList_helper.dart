// ignore_for_file: file_names
import 'dart:convert';

import 'package:path/path.dart';
import 'package:shoppinglist_app/model/cart_model.dart';
import 'package:shoppinglist_app/model/category_model.dart';
import 'package:shoppinglist_app/model/item_model.dart';
import 'package:shoppinglist_app/model/shoppinglist_detail_model.dart';
import 'package:shoppinglist_app/model/shoppinglist_model.dart';
import 'package:shoppinglist_app/model/user_model.dart';
import 'package:sqflite/sqflite.dart';

class ShoppinglistHelper {
  String dbName = "shoplistdb.db";
  String categoryTable = "category";
  String itemTable = "shopping_items";
  String appSettings = "settings";
  String userTable = "users";
  String shoppingListTable = "shopping_list";
  String listDetailTable = "shopping_list_details";
  String cartTable = "cart_items";
  String itemView = "v_items";
  String cartView = "v_cart_items";

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), dbName);
    // print('============================');
    // print('DB NAME = $dbName');
    // print('DB PATH = $path');
    // print('DB EXISTS BEFORE OPEN = ${await databaseExists(path)}');
    // print('============================');
    return await openDatabase(
      path,
      version: 1,
      // Enable foreign key
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },

      // Create database
      onCreate: (db, version) async {
        // Category table
        await db.execute("""
          CREATE TABLE $categoryTable(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE,
            icon TEXT NOT NULL
          )
        """);

        // Item table
        await db.execute("""
          CREATE TABLE $itemTable(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            category_id INTEGER,
            estimate_price REAL,
            discount REAL,
            unit TEXT,
            tags TEXT,
            description TEXT,
            image TEXT,
            is_fav INTEGER DEFAULT 0,
            status INTEGER DEFAULT 1,

            FOREIGN KEY (category_id)
              REFERENCES $categoryTable(id)
          )
        """);

        // Item view
        await db.execute("""
          CREATE VIEW $itemView AS

          SELECT
            i.id,
            i.name,
            i.category_id,
            c.name AS category_name,
            i.estimate_price,
            i.discount,
            i.unit,
            i.tags,
            i.description,
            i.image,
            i.is_fav,
            i.status

          FROM $itemTable i

          LEFT JOIN $categoryTable c
            ON i.category_id = c.id
        """);

        // App settings
        await db.execute("""
          CREATE TABLE $appSettings(
            setting_key TEXT PRIMARY KEY,
            value INTEGER NOT NULL
          )
        """);

        // User profile
        await db.execute("""
          CREATE TABLE $userTable(
            id INTEGER PRIMARY KEY,
            name TEXT,
            email TEXT,
            phone TEXT,
            preference TEXT,
            store_location TEXT,
            image TEXT
          )
        """);

        // Default local user
        await db.insert(userTable, {
          'id': 1,
          'name': 'Local Shopper',
          'email': '',
          'phone': '',
          'preference': '',
          'store_location': '',
          'image': 'Assets/image.png',
        });

        // Shopping list table
        await db.execute("""
          CREATE TABLE $shoppingListTable(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            list_name TEXT NOT NULL,
            create_date TEXT,
            complete_date TEXT,
            reminder_date TEXT,
            notification_id INTEGER,
            status INTEGER DEFAULT 0
          )
        """);

        // Shopping list details table
        await db.execute("""
          CREATE TABLE $listDetailTable(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            list_id INTEGER NOT NULL,
            item_id INTEGER NOT NULL,
            quantity INTEGER NOT NULL DEFAULT 1,
            is_purchased INTEGER NOT NULL DEFAULT 0,

            FOREIGN KEY (list_id)
              REFERENCES $shoppingListTable(id)
              ON DELETE CASCADE,

            FOREIGN KEY (item_id)
              REFERENCES $itemTable(id),

            UNIQUE(list_id, item_id)
          )
        """);

        // Cart table
        await db.execute("""
          CREATE TABLE $cartTable(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            item_id INTEGER NOT NULL UNIQUE,
            quantity INTEGER NOT NULL DEFAULT 1,
            is_purchased INTEGER NOT NULL DEFAULT 0,

            FOREIGN KEY (item_id)
              REFERENCES $itemTable(id)
              ON DELETE CASCADE
          )
        """);

        // Cart view
        await db.execute("""
          CREATE VIEW $cartView AS

          SELECT
            c.id AS cart_id,
            c.quantity,
            c.is_purchased,
            i.*

          FROM $cartTable c

          INNER JOIN $itemView i
            ON c.item_id = i.id
        """);
      },
    );
  }

  // Category
  Future<int> insertCategory(CategoryModel category) async {
    var openDB = await initDatabase();
    final data = await openDB.insert(categoryTable, category.toMap());
    return data;
  }

  Future<List<CategoryModel>> getAllCategories() async {
    var openDB = await initDatabase();

    var data = await openDB.query(
      categoryTable,
      orderBy: "CASE WHEN LOWER(name) = 'other' THEN 1 ELSE 0 END, id ASC",
    );
    return data.map((e) => CategoryModel.fromMap(e)).toList();
  }
  
  Future<List<CategoryModel>> searchCategory(String search) async {
    var openDB = await initDatabase();

    var data = await openDB.query(
      categoryTable,
      where: 'name LIKE ?',
      whereArgs: ['%$search%'],
      orderBy: 'id ASC',
    );

    return data.map((e) => CategoryModel.fromMap(e)).toList();
  }

  // Item
  Future<int> insertItem(ItemModel item) async {
    var openDB = await initDatabase();

    return await openDB.insert(itemTable, item.toMap());
  }

  Future<List<ItemModel>> getAllItems() async {
    var openDB = await initDatabase();

    var data = await openDB.query(
      itemView,
      where: 'status = ?',
      whereArgs: [1],
      orderBy: 'id DESC',
    );

    return data.map((e) => ItemModel.fromMap(e)).toList();
  }

  Future<List<ItemModel>> getItemByCategory(int categoryId) async {
    var openDB = await initDatabase();
    var data = await openDB.query(
      itemView,
      where: 'category_id = ? and status = ?',
      whereArgs: [categoryId, 1],
      orderBy: 'id DESC',
    );

    return data.map((e) => ItemModel.fromMap(e)).toList();
  }

  Future<void> updateItem(ItemModel item) async {
    var openDB = await initDatabase();
    await openDB.update(
      itemTable,
      {
        'name': item.name,
        'category_id': item.categoryId,
        'estimate_price': item.estimatedPrice,
        'discount': item.discount,
        'unit': item.unit,
        'tags': jsonEncode(item.tags.map((e) => e.toMap()).toList()),
        'description': item.description,
        'image': item.img,
        'is_fav': item.isFav ? 1 : 0,
        'status': item.status ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  // search
  Future<List<ItemModel>> searchItem(String search) async {
    var openDB = await initDatabase();

    if (search.trim().isEmpty) {
      return await getAllItems();
    }
    final keyword = search.trim();
    var data = await openDB.query(
      itemView,
      where: '''
      status = ? AND (
        name LIKE ? OR
        category_name LIKE ?
      )
    ''',
      whereArgs: [1, '%$keyword%', '%$keyword%'],
      orderBy: 'id DESC',
    );

    return data.map((e) => ItemModel.fromMap(e)).toList();
  }

  // filter search item
  Future<List<ItemModel>> filterSearchItem(String filter) async {
    final db = await initDatabase();

    String where = 'status = ?';
    List<dynamic> whereArgs = [1];
    String orderBy = 'id DESC';
    if (filter == 'Favorite') {
      where += ' AND is_fav = ?';
      whereArgs.add(1);
    }

    if (filter == 'On Sale') {
      where += ' AND discount IS NOT NULL AND discount > 0';
    }

    if (filter == 'Low Price') {
      orderBy = 'estimate_price ASC';
    }

    if (filter == 'High Price') {
      orderBy = 'estimate_price DESC';
    }

    final data = await db.query(
      itemView,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
    );
    return data.map((e) => ItemModel.fromMap(e)).toList();
  }

  // filter tag
  Future<List<ItemModel>> filterItemByTag(String tag) async {
    final db = await initDatabase();
    if (tag == 'All') {
      return await getAllItems();
    }
    final data = await db.query(
      itemView,
      where: '''
      status = ?
      AND tags LIKE ?
    ''',
      whereArgs: [1, '%"name":"$tag"%'],
      orderBy: 'id DESC',
    );
    return data.map((e) => ItemModel.fromMap(e)).toList();
  }

  // all tag from item
  Future<List<String>> getAllItemTags() async {
    var openDB = await initDatabase();

    final data = await openDB.query(
      itemView,
      columns: ['tags'],
      where: 'status = ?',
      whereArgs: [1],
    );

    final Set<String> tags = {};
    for (final row in data) {
      final tagData = row['tags'];
      if (tagData == null || tagData.toString().isEmpty) {
        continue;
      }
      final List<dynamic> decoded = jsonDecode(tagData.toString());
      for (final tag in decoded) {
        final name = tag['name']?.toString().trim();

        if (name != null && name.isNotEmpty) {
          tags.add(name);
        }
      }
    }
    final result = tags.toList();
    result.sort();
    return result;
  }

  Future<void> deleteItem(int id) async {
    var openDB = await initDatabase();

    await openDB.update(
      itemTable,
      {'status': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getTotalItems() async {
    var openDB = await initDatabase();
    final result = await openDB.rawQuery("""
      SELECT COUNT(*) AS total
      FROM $itemTable
    """);
    return result.first['total'] as int? ?? 0;
  }

  Future<Map<int, int>> getItemCountsByCategory() async {
    var openDB = await initDatabase();

    final result = await openDB.rawQuery("""
      SELECT
        category_id,
        COUNT(*) AS total_items
      FROM $itemTable
      WHERE status = 1
      GROUP BY category_id
    """);

    return {
      for (final row in result)
        row['category_id'] as int: row['total_items'] as int,
    };
  }

  Future<int> getTotalFavItems() async {
    var openDB = await initDatabase();

    final result = await openDB.rawQuery("""
      SELECT COUNT(*) AS total
      FROM $itemTable
      WHERE is_fav = 1
    """);

    return result.first['total'] as int? ?? 0;
  }

  Future<void> updateFavorite(int id, bool isFav) async {
    var openDB = await initDatabase();
    await openDB.update(
      itemTable,
      {'is_fav': isFav ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<ItemModel>> getFavorite() async {
    var openDB = await initDatabase();

    var data = await openDB.query(
      itemView,
      where: 'is_fav = ? AND status = ?',
      whereArgs: [1, 1],
      orderBy: 'id DESC',
    );
    return data.map((e) => ItemModel.fromMap(e)).toList();
  }

  Future<List<ItemModel>> filterItemsCategory(
    int categoryId,
    String filter,
  ) async {
    final db = await initDatabase();
    String where = 'category_id = ? AND status = ?';
    List<dynamic> whereArgs = [categoryId, 1];
    String orderBy = 'id DESC';
    if (filter == 'Favorite') {
      where += ' AND is_fav = ?';
      whereArgs.add(1);
    }
    if (filter == 'On Sale') {
      where += ' AND discount IS NOT NULL AND discount > 0';
    }
    if (filter == 'Low Price') {
      orderBy = 'estimate_price ASC';
    }
    if (filter == 'High Price') {
      orderBy = 'estimate_price DESC';
    }
    final data = await db.query(
      itemView,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
    );
    return data.map((e) => ItemModel.fromMap(e)).toList();
  }

  // Dark mode
  Future<void> saveDarkMode(bool isDark) async {
    var openDB = await initDatabase();

    await openDB.insert(appSettings, {
      'setting_key': 'dark_mode',
      'value': isDark ? 1 : 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<bool> getDarkMode() async {
    var openDB = await initDatabase();

    var data = await openDB.query(
      appSettings,
      where: 'setting_key = ?',
      whereArgs: ['dark_mode'],
      limit: 1,
    );

    if (data.isEmpty) {
      return false;
    }

    return data.first['value'] == 1;
  }

  // User
  Future<UserModel> getUser() async {
    var openDB = await initDatabase();

    var data = await openDB.query(
      userTable,
      where: 'id = ?',
      whereArgs: [1],
      limit: 1,
    );

    if (data.isEmpty) {
      return const UserModel();
    }

    return UserModel.fromMap(data.first);
  }

  Future<int> updateUser(UserModel user) async {
    var openDB = await initDatabase();

    return await openDB.update(
      userTable,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Cart
  Future<int> saveCartItem(int itemId, int qty) async {
    var openDB = await initDatabase();

    return await openDB.insert(cartTable, {
      'item_id': itemId,
      'quantity': qty,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<CartModel>> getCartItems() async {
    var openDB = await initDatabase();

    var data = await openDB.query(cartView);

    return data.map((e) {
      return CartModel(
        item: ItemModel.fromMap(e),
        quantity: e['quantity'] as int? ?? 1,
        isPurchased: e['is_purchased'] == 1,
      );
    }).toList();
  }

  Future<int> updateCartQuantity(int itemId, int qty) async {
    var openDB = await initDatabase();

    return await openDB.update(
      cartTable,
      {'quantity': qty},
      where: 'item_id = ?',
      whereArgs: [itemId],
    );
  }

  Future<int> updateCartPurchased(int itemId, bool isPurchased) async {
    var openDB = await initDatabase();
    return await openDB.update(
      cartTable,
      {'is_purchased': isPurchased ? 1 : 0},
      where: 'item_id = ?',
      whereArgs: [itemId],
    );
  }

  Future<int> deleteCartItem(int itemId) async {
    var openDB = await initDatabase();

    return await openDB.delete(
      cartTable,
      where: 'item_id = ?',
      whereArgs: [itemId],
    );
  }

  Future<int> clearCart() async {
    var openDB = await initDatabase();

    return await openDB.delete(cartTable);
  }

  Future<int> getCartCount() async {
    var openDB = await initDatabase();

    final result = await openDB.rawQuery("""
      SELECT COUNT(*) AS total
      FROM $cartTable
    """);

    return result.first['total'] as int? ?? 0;
  }

  Future<int> getCartTotalItems() async {
    var openDB = await initDatabase();

    final result = await openDB.rawQuery("""
      SELECT SUM(quantity) AS total
      FROM $cartTable
    """);

    return result.first['total'] as int? ?? 0;
  }

  Future<int> getCartPurchasedItems() async {
    var openDB = await initDatabase();

    final result = await openDB.rawQuery("""
    SELECT SUM(quantity) AS total
    FROM $cartTable
    WHERE is_purchased = 1
  """);

    return result.first['total'] as int? ?? 0;
  }

  Future<double> getCartSubTotal() async {
    var openDB = await initDatabase();

    final result = await openDB.rawQuery("""
      SELECT SUM(
        estimate_price * quantity
      ) AS subtotal

      FROM $cartView
    """);

    return (result.first['subtotal'] as num?)?.toDouble() ?? 0.0;
  }

  Future<double> getCartDiscount() async {
    var openDB = await initDatabase();

    final result = await openDB.rawQuery("""
      SELECT SUM(
        estimate_price *
        (
          IFNULL(discount, 0) / 100.0
        ) *
        quantity
      ) AS discount

      FROM $cartView
    """);

    return (result.first['discount'] as num?)?.toDouble() ?? 0.0;
  }

  Future<double> getCartFinalPrice() async {
    var openDB = await initDatabase();

    final result = await openDB.rawQuery("""
      SELECT SUM(
        (
          estimate_price -
          (
            estimate_price *
            (
              IFNULL(discount, 0) / 100.0
            )
          )
        ) * quantity
      ) AS total

      FROM $cartView
    """);

    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<int> saveCartToShoppingList({
    required String listName,
    DateTime? reminderDate,
  }) async {
    var openDB = await initDatabase();

    return await openDB.transaction((txn) async {
      final cartItems = await txn.query(cartTable);

      if (cartItems.isEmpty) {
        throw Exception('Cart is empty');
      }

      final shoppingList = ShoppingListModel(
        listName: listName.trim(),
        createDate: DateTime.now().toIso8601String(),
        completeDate: null,
        reminderDate: reminderDate?.toIso8601String(),
        notificationId: null,
        status: false,
      );

      final listId = await txn.insert(shoppingListTable, shoppingList.toMap());

      for (final cart in cartItems) {
        await txn.insert(listDetailTable, {
          'list_id': listId,
          'item_id': cart['item_id'],
          'quantity': cart['quantity'] ?? 1,
          'is_purchased': cart['is_purchased'] ?? 0,
        });
      }

      return listId;
    });
  }

  // shopping list data
  Future<List<ShoppingListModel>> getAllShoppingList() async {
    var openDB = await initDatabase();
    var data = await openDB.query(
      shoppingListTable,
      where: 'status = ?',
      whereArgs: [0],
      orderBy: 'id DESC',
    );

    return data.map((e) => ShoppingListModel.fromMap(e)).toList();
  }

  // update notification id
  Future<int> updateShoppingListNotificationId(
    int listId,
    int? notificationId,
  ) async {
    var openDB = await initDatabase();

    return await openDB.update(
      shoppingListTable,
      {'notification_id': notificationId},
      where: 'id = ?',
      whereArgs: [listId],
    );
  }

  Future<int?> getShoppingListNotificationId(int listId) async {
    var openDB = await initDatabase();

    final data = await openDB.query(
      shoppingListTable,
      columns: ['notification_id'],
      where: 'id = ?',
      whereArgs: [listId],
      limit: 1,
    );

    if (data.isEmpty) {
      return null;
    }

    return data.first['notification_id'] as int?;
  }

  // complete purchased
  Future<void> completeShoppingList(int listId) async {
    var openDB = await initDatabase();
    await openDB.transaction((txn) async {
      // mark all items purchased
      await txn.update(
        listDetailTable,
        {'is_purchased': 1},
        where: 'list_id = ?',
        whereArgs: [listId],
      );

      await txn.update(
        shoppingListTable,
        {'status': 1, 'complete_date': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [listId],
      );
    });
  }

  // only completed list
  Future<List<ShoppingListModel>> getCompletedShoppingList() async {
    var openDB = await initDatabase();
    var data = await openDB.query(
      shoppingListTable,
      where: 'status = ?',
      whereArgs: [1],
      orderBy: 'complete_date DESC',
    );
    return data.map((e) => ShoppingListModel.fromMap(e)).toList();
  }

  Future<List<ShoppingListDetailModel>> getShoppingListDetails(
    int listId,
  ) async {
    var openDB = await initDatabase();
    final data = await openDB.rawQuery(
      '''
    SELECT
      d.id AS detail_id,
      d.list_id,
      d.item_id,
      d.quantity,
      d.is_purchased,
      i.*

    FROM $listDetailTable d
    INNER JOIN $itemView i
      ON d.item_id = i.id

    WHERE d.list_id = ?

    ORDER BY d.id DESC
    ''',
      [listId],
    );
    return data.map((e) => ShoppingListDetailModel.fromMap(e)).toList();
  }

  Future<int> getShoppingListItemCount(int listId) async {
    var openDB = await initDatabase();
    final result = await openDB.rawQuery(
      '''
    SELECT SUM(quantity) AS total
    FROM $listDetailTable
    WHERE list_id = ?
    ''',
      [listId],
    );
    return result.first['total'] as int? ?? 0;
  }

  // update purchased
  Future<void> updateShoppingListDetailPurchased(
    int listId,
    int itemId,
    bool isPurchased,
  ) async {
    var openDB = await initDatabase();

    await openDB.update(
      listDetailTable,
      {'is_purchased': isPurchased ? 1 : 0},
      where: 'list_id = ? AND item_id = ?',
      whereArgs: [listId, itemId],
    );
  }

  // increment quantity
  Future<void> incrementShoppingListDetail(int listId, int itemId) async {
    var openDB = await initDatabase();

    await openDB.rawUpdate(
      '''
    UPDATE $listDetailTable
    SET quantity = quantity + 1
    WHERE list_id = ? AND item_id = ?
    ''',
      [listId, itemId],
    );
  }

  // decrement quantity
  Future<void> decrementShoppingListDetail(int listId, int itemId) async {
    var openDB = await initDatabase();

    await openDB.rawUpdate(
      '''
    UPDATE $listDetailTable
    SET quantity = quantity - 1
    WHERE list_id = ?
    AND item_id = ?
    AND quantity > 1
    ''',
      [listId, itemId],
    );
  }

  // remove shopping list item
  Future<void> removeShoppingListDetail(int listId, int itemId) async {
    var openDB = await initDatabase();

    await openDB.delete(
      listDetailTable,
      where: 'list_id = ? AND item_id = ?',
      whereArgs: [listId, itemId],
    );
  }

  Future<void> deleteShoppingList(int listId) async {
    var openDB = await initDatabase();

    await openDB.delete(
      shoppingListTable,
      where: 'id = ?',
      whereArgs: [listId],
    );
  }

  // load shopping list to cart
  Future<void> loadShoppingListToCart(int listId) async {
    var openDB = await initDatabase();

    await openDB.transaction((txn) async {
      final details = await txn.query(
        listDetailTable,
        columns: ['item_id', 'quantity', 'is_purchased'],
        where: 'list_id = ?',
        whereArgs: [listId],
      );

      // clear current cart
      await txn.delete(cartTable);

      // copy saved items into cart
      for (final detail in details) {
        await txn.insert(cartTable, {
          'item_id': detail['item_id'],
          'quantity': detail['quantity'] ?? 1,
          'is_purchased': detail['is_purchased'] ?? 0,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }

  // update shopping list from cart
  Future<void> updateShoppingListFromCart({
    required int listId,
    required String listName,
    DateTime? reminderDate,
  }) async {
    var openDB = await initDatabase();

    await openDB.transaction((txn) async {
      final cartItems = await txn.query(cartTable);

      if (cartItems.isEmpty) {
        throw Exception('Cart is empty');
      }

      await txn.update(
        shoppingListTable,
        {
          'list_name': listName.trim(),
          'reminder_date': reminderDate?.toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [listId],
      );

      await txn.delete(
        listDetailTable,
        where: 'list_id = ?',
        whereArgs: [listId],
      );

      for (final cart in cartItems) {
        await txn.insert(listDetailTable, {
          'list_id': listId,
          'item_id': cart['item_id'],
          'quantity': cart['quantity'] ?? 1,
          'is_purchased': cart['is_purchased'] ?? 0,
        });
      }
    });
  }

  // sync shopping list items from cart
  Future<void> syncShoppingListItemsFromCart(int listId) async {
    var openDB = await initDatabase();

    await openDB.transaction((txn) async {
      final cartItems = await txn.query(cartTable);

      if (cartItems.isEmpty) {
        throw Exception('Cart is empty');
      }

      await txn.delete(
        listDetailTable,
        where: 'list_id = ?',
        whereArgs: [listId],
      );

      for (final cart in cartItems) {
        await txn.insert(listDetailTable, {
          'list_id': listId,
          'item_id': cart['item_id'],
          'quantity': cart['quantity'] ?? 1,
          'is_purchased': cart['is_purchased'] ?? 0,
        });
      }
    });
  }

  // search list
  Future<List<ShoppingListModel>> searchShoppingList(String search) async {
    var openDB = await initDatabase();
    if (search.trim().isEmpty) {
      return await getAllShoppingList();
    }
    final keyword = search.trim();
    final data = await openDB.query(
      shoppingListTable,
      where: '''
      status = ?
      AND list_name LIKE ?
    ''',
      whereArgs: [0, '%$keyword%'],
      orderBy: 'id DESC',
    );

    return data.map((e) => ShoppingListModel.fromMap(e)).toList();
  }

  Future<List<ShoppingListModel>> searchCompletedShoppingList(
    String search,
  ) async {
    var openDB = await initDatabase();

    if (search.trim().isEmpty) {
      return await getCompletedShoppingList();
    }

    final keyword = search.trim();

    final data = await openDB.query(
      shoppingListTable,
      where: '''
      status = ?
      AND list_name LIKE ?
    ''',
      whereArgs: [1, '%$keyword%'],
      orderBy: 'complete_date DESC',
    );

    return data.map((e) => ShoppingListModel.fromMap(e)).toList();
  }

  // reuse history list to cart
  Future<void> reuseShoppingListToCart(int listId) async {
    var openDB = await initDatabase();

    await openDB.transaction((txn) async {
      final details = await txn.query(
        listDetailTable,
        columns: ['item_id', 'quantity'],
        where: 'list_id = ?',
        whereArgs: [listId],
      );

      // replace current cart
      await txn.delete(cartTable);

      for (final detail in details) {
        await txn.insert(cartTable, {
          'item_id': detail['item_id'],
          'quantity': detail['quantity'] ?? 1,

          // new shopping
          'is_purchased': 0,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }

  // active shopping estimate cost
  Future<double> getActiveShoppingEstimateCost() async {
    var openDB = await initDatabase();
    final result = await openDB.rawQuery('''
        SELECT SUM(
          (
            i.estimate_price -
            (
              i.estimate_price *
              (IFNULL(i.discount, 0) / 100.0)
            )
          ) * d.quantity
        ) AS total
        FROM $listDetailTable d
        INNER JOIN $shoppingListTable l
          ON d.list_id = l.id
        INNER JOIN $itemTable i
          ON d.item_id = i.id

        WHERE l.status = 0
    ''');

    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  // total items in active shopping lists
  Future<int> getActiveShoppingTotalItems() async {
    var openDB = await initDatabase();

    final result = await openDB.rawQuery('''
    SELECT SUM(d.quantity) AS total

    FROM $listDetailTable d

    INNER JOIN $shoppingListTable l
      ON d.list_id = l.id

    WHERE l.status = 0
    ''');

    return result.first['total'] as int? ?? 0;
  }

  // purchased items
  Future<int> getActiveShoppingPurchasedItems() async {
    var openDB = await initDatabase();

    final result = await openDB.rawQuery('''
    SELECT SUM(d.quantity) AS total

    FROM $listDetailTable d

    INNER JOIN $shoppingListTable l
      ON d.list_id = l.id

    WHERE l.status = 0
    AND d.is_purchased = 1
    ''');

    return result.first['total'] as int? ?? 0;
  }

  // remaining items
  Future<int> getActiveShoppingRemainingItems() async {
    var openDB = await initDatabase();

    final result = await openDB.rawQuery('''
    SELECT SUM(d.quantity) AS total

    FROM $listDetailTable d

    INNER JOIN $shoppingListTable l
      ON d.list_id = l.id

    WHERE l.status = 0
    AND d.is_purchased = 0
    ''');

    return result.first['total'] as int? ?? 0;
  }

  Future<double> getCompletedPurchaseTotal() async {
    var openDB = await initDatabase();
    final result = await openDB.rawQuery('''
    SELECT SUM(
      (
        i.estimate_price -
        (
          i.estimate_price *
          (IFNULL(i.discount, 0) / 100.0)
        )
      ) * d.quantity
    ) AS total

    FROM $listDetailTable d

    INNER JOIN $shoppingListTable l
      ON d.list_id = l.id

    INNER JOIN $itemTable i
      ON d.item_id = i.id
    WHERE l.status = 1
    ''');
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }
}
