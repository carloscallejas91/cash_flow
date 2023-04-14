import "dart:async";

import "package:path/path.dart";
import "package:sqflite/sqflite.dart";

mixin DatabaseHelper {
  static const String dbName = "cash_flow_09.db";
  static const int dbVersion = 1;
  static const String cashFlowTabName = "cash_flow_tab";
  static const String categoryTabName = "category_tab";
  static const String descriptionTabName = "description_tab";
  static Database? _db;

  static Future<Database?> get db async {
    if (_db != null) return _db;

    return _initDb();
  }

  static Future<Database> _initDb() async {
    final String databasesPath = await getDatabasesPath();
    final String path = join(databasesPath, dbName);
    return openDatabase(path, version: dbVersion, onCreate: _onCreate);
  }

  static Future<void> _onCreate(Database db, int newVersion) async {
    await db.execute(
      "CREATE TABLE $cashFlowTabName "
      "(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
      "type TEXT, "
      "category TEXT, "
      "description TEXT, "
      "value REAL, "
      "typeOfPayment TEXT, "
      "observation TEXT, "
      "status TEXT, "
      "dueDate TEXT, "
      "settledIn TEXT, "
      "createIn TEXT)",
    );

    await db.execute(
      "CREATE TABLE $categoryTabName "
      "(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
      "category TEXT, "
      "type TEXT)",
    );

    await db.execute(
      "CREATE TABLE $descriptionTabName "
      "(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
      "description TEXT, "
      "categoryId INTEGER, "
      "FOREIGN KEY (categoryId) REFERENCES $categoryTabName (id))",
    );

    await db.close();
  }

  // Category provider
  static Future<int> insertCategory(Map<String, dynamic> category) async {
    final dbClient = await db;
    return dbClient!.insert(categoryTabName, category);
  }

  static Future<int> updateCategory(
    Map<String, dynamic> category,
    int id,
  ) async {
    final dbClient = await db;
    return dbClient!.update(
      categoryTabName,
      category,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  static Future<int> deleteCategory(int id) async {
    final dbClient = await db;
    return dbClient!.delete(categoryTabName, where: "id = ?", whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> getCategoryById(
    int id,
  ) async {
    final dbClient = await db;
    return dbClient!.query(
      categoryTabName,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, dynamic>>> getCategoryByName(
    String name,
  ) async {
    final dbClient = await db;
    return dbClient!.query(
      categoryTabName,
      where: "category LIKE ?",
      whereArgs: ["%$name%"],
    );
  }

  static Future<List<Map<String, dynamic>>> getCategoryByType(
    String type,
  ) async {
    final dbClient = await db;
    return dbClient!.query(
      categoryTabName,
      where: "type LIKE ?",
      whereArgs: ["%$type%"],
    );
  }

  // Description provider
  static Future<int> insertDescription(Map<String, dynamic> description) async {
    final dbClient = await db;
    return dbClient!.insert(descriptionTabName, description);
  }

  static Future<int> updateDescription(
    Map<String, dynamic> description,
    int id,
  ) async {
    final dbClient = await db;
    return dbClient!.update(
      descriptionTabName,
      description,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  static Future<int> deleteDescription(int id) async {
    final dbClient = await db;
    return dbClient!
        .delete(descriptionTabName, where: "id = ?", whereArgs: [id]);
  }

  static Future<int> deleteDescriptionByCategoryId(int id) async {
    final dbClient = await db;
    return dbClient!
        .delete(descriptionTabName, where: "categoryId = ?", whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> getDescriptionByCategoryID(
    int categoryId,
  ) async {
    final dbClient = await db;
    return dbClient!.query(
      descriptionTabName,
      where: "categoryId = ?",
      whereArgs: [categoryId],
    );
  }

  // Cash Flow provider
  static Future<int> insertCashFlowItem(Map<String, dynamic> cashFlow) async {
    final dbClient = await db;
    return dbClient!.insert(cashFlowTabName, cashFlow);
  }

  static Future<int> updateCashFlowItem(
    Map<String, dynamic> cashFlow,
    int id,
  ) async {
    final dbClient = await db;
    return dbClient!.update(
      cashFlowTabName,
      cashFlow,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  static Future<int> deleteCashFlowItem(int id) async {
    final dbClient = await db;
    return dbClient!.delete(cashFlowTabName, where: "id = ?", whereArgs: [id]);
  }

  static Future<int> deleteAllCashFlow() async {
    final dbClient = await db;
    return dbClient!.delete(cashFlowTabName);
  }

  static Future<List<Map<String, dynamic>>> getAllInRangeCashFlowItems(
    String startDate,
    String endDate,
    String type,
  ) async {
    final dbClient = await db;
    return dbClient!.query(
      cashFlowTabName,
      where:
          "settledIn >= ? and settledIn <= ? and type LIKE ? or dueDate >= ? and dueDate <= ? and type LIKE ?",
      whereArgs: [startDate, endDate, "%$type%", startDate, endDate, "%$type%"],
    );
  }

  static Future<List<Map<String, dynamic>>> getAllCashFlowItemsByStatus(
    String status,
  ) async {
    final dbClient = await db;
    return dbClient!.query(
      cashFlowTabName,
      where: "status = ?",
      whereArgs: [status],
    );
  }

  static Future<List<Map<String, dynamic>>> getAllInRangeCashFlowItemsByStatus(
    String startDate,
    String endDate,
    String status,
  ) async {
    final dbClient = await db;
    return dbClient!.query(
      cashFlowTabName,
      where: "settledIn >= ? and settledIn <= ? and status = ?",
      whereArgs: [startDate, endDate, status],
    );
  }

  static Future<List<Map<String, dynamic>>> getAllSettledInRangeCashFlowItems(
    String startDate,
    String endDate,
    String type,
  ) async {
    final dbClient = await db;
    return dbClient!.query(
      cashFlowTabName,
      where:
          "status = 'Liquidado' and settledIn >= ? and settledIn <= ? and type LIKE ?",
      whereArgs: [startDate, endDate, "%$type%"],
    );
  }

  static Future<List<Map<String, dynamic>>> getAllUnsettledInRangeCashFlowItems(
    String startDate,
    String endDate,
    String? type,
  ) async {
    final dbClient = await db;
    return dbClient!.query(
      cashFlowTabName,
      where:
          "status = 'Não liquidado' and dueDate >= ? and dueDate <= ? and type LIKE ?",
      whereArgs: [startDate, endDate, "%$type%"],
    );
  }


}
