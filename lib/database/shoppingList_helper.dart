// ignore_for_file: file_names

import 'package:path/path.dart';
import 'package:shoppinglist_app/model/category_model.dart';
import 'package:shoppinglist_app/model/item_model.dart';
import 'package:shoppinglist_app/model/user_model.dart';
import 'package:sqflite/sqflite.dart';

class ShoppinglistHelper {
  String dbName = "shoplistdb124.db";
  String categoryTable = "category";
  String itemTable = "shopping_items";
  String itemView = "v_items";
  String appSettings = "settings";
  String userTable = "users";

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), dbName);

    return await openDatabase(
      path,
      version: 2,
      // enable foreign key
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },

      onCreate: (db, version) async {
        // category table
        await db.execute("""
        CREATE TABLE $categoryTable(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL UNIQUE,
          icon TEXT NOT NULL
        )
      """);

        // item table
        await db.execute("""
        CREATE TABLE shopping_items(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            category_id INTEGER,
            estimate_price REAL,
            unit TEXT,
            description TEXT,
            image TEXT,
            is_fav INTEGER DEFAULT 0,
            status INTEGER DEFAULT 1,
            FOREIGN KEY (category_id) REFERENCES category(id)
          )
        """);

        // view item
        await db.execute("""
        CREATE VIEW $itemView AS
            SELECT
                    i.id,
                    i.name,
                    c.name AS category_name,
                    i.estimate_price,
                    i.unit,
                    i.description,
                    i.image,
                    i.is_fav,
                    i.status
          FROM $itemTable i
          LEFT JOIN $categoryTable c
          ON i.category_id = c.id
      """);

        // app settings
        await db.execute("""
          CREATE TABLE $appSettings(
            setting_key TEXT PRIMARY KEY,
            value INTEGER NOT NULL
          )
        """);

        // profile
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

        // guess acc user
        await db.insert(userTable, {
          'id': 1,
          'name': 'Local Shopper',
          'email': '',
          'phone': '',
          'preference': '',
          'store_location': '',
          'image': 'Assets/image.png',
        });
      },

      onUpgrade: (db, oldVersion, newVersion) async {
        // upgrade user table
        if (oldVersion < 2) {
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

          // guess acc user
          await db.insert(userTable, {
            'id': 1,
            'name': 'Local Shopper',
            'email': '',
            'phone': '',
            'preference': '',
            'store_location': '',
            'image': 'Assets/image.png',
          }, conflictAlgorithm: ConflictAlgorithm.ignore);
        }
      },
    );
  }

  // insert category
  Future<int> insertCategory(CategoryModel category) async {
    var openDB = await initDatabase();

    return await openDB.insert(categoryTable, category.toMap());
  }

  // get all categories
  Future<List<CategoryModel>> getAllCategories() async {
    var openDB = await initDatabase();

    var data = await openDB.query(
      categoryTable,
      orderBy: "CASE WHEN LOWER(name) = 'other' THEN 1 ELSE 0 END, id ASC",
    );

    return data.map((e) => CategoryModel.fromMap(e)).toList();
  }

  // search category
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

  // inseert item
  Future<int> insertItem(ItemModel item) async {
    var openDB = await initDatabase();
    return await openDB.insert(itemTable, item.toMap());
  }

  // get all items
  Future<List<ItemModel>> getAllItems() async {
    var openDB = await initDatabase();
    var data = await openDB.query(
      itemView,
      where: 'status = ?',
      whereArgs: [1],
      orderBy: 'id ASC',
    );
    return data.map((e) => ItemModel.fromMap(e)).toList();
  }

  // update isFav
  Future<void> updateFavorite(int id, bool isFav) async {
    var openDB = await initDatabase();
    await openDB.update(
      itemTable,
      {'is_fav': isFav ? 1 : 0},
      where: 'id=?',
      whereArgs: [id],
    );
  }

  // get only fav items
  Future<List<ItemModel>> getFavorite() async {
    var openDB = await initDatabase();
    var data = await openDB.query(
      itemTable,
      where: 'is_fav = ? and status = ?',
      whereArgs: [1, 1],
      orderBy: 'id DESC',
    );
    return data.map((e) => ItemModel.fromMap(e)).toList();
  }

  // save dark mode
  Future<void> saveDarkMode(bool isDark) async {
    var openDB = await initDatabase();
    await openDB.insert(appSettings, {
      'setting_key': 'dark_mode',
      'value': isDark ? 1 : 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // get darkMode
  // ignore: unused_element
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

  // get user
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

  // update user
  Future<int> updateUser(UserModel user) async {
    var openDB = await initDatabase();

    return await openDB.update(
      userTable,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }
}
