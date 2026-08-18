import 'package:path/path.dart';
import 'package:shoppinglist_app/model/category_model.dart';
import 'package:shoppinglist_app/model/item_model.dart';
import 'package:sqflite/sqflite.dart';

class ShoppinglistHelper {
  String dbName = "shoplistdb1234.db";
  String categoryTable = "category";
  String itemTable = "shopping_items";
  String itemView = "v_items";
  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), dbName);

    return await openDatabase(
      path,
      version: 1,
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
          CREATE TABLE $itemTable(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            category_id INTEGER, 
            estimate_price REAL,
            unit TEXT,
            description TEXT,
            image TEXT,
            is_Fav INTEGER DEFAULT 0,
            status INTEGER DEFAULT 1,
            FOREIGN KEY (category_id) REFERENCE $categoryTable (id)
          )
          """);
        

        // view item 
        await db.execute("""
              CREATE OR REPLACE VIEW AS 
              SELECT
                i.*,
                c.name as category_name
              FROM $itemTable i 
              LEFT JOIN $categoryTable c on i.category_id = c.id
          """);
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

  // get all categories
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





}
