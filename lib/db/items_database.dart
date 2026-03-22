import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../model/local/items.dart';

class ItemsDatabase {
  static final ItemsDatabase instance = ItemsDatabase._init();

  static Database? _database;

  ItemsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('items.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, password: "_jav.d/e.java",onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const doubleType = 'REAL NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE $tableItems ( 
      ${ItemFields.id} $idType, 
      ${ItemFields.receiptId} $integerType,
      ${ItemFields.name} $textType,
      ${ItemFields.uom} TEXT,  -- optional
      ${ItemFields.qty} $integerType,
      ${ItemFields.unit_price} $doubleType,
      ${ItemFields.tax_code} TEXT,  -- optional
      ${ItemFields.tax_amount} REAL, -- optional
      ${ItemFields.discount} REAL,   -- optional
      ${ItemFields.amount} $doubleType
    )
    ''');
  }

  Future<LocalItems> create(LocalItems items) async {
    final db = await instance.database;

    // final json = note.toJson();
    // final columns =
    //     '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tableItems, items.toJson());
    return items.copy(id: id);
  }

  Future<List<LocalItems>> readItems(int receiptId) async {
    final db = await instance.database;

    final maps = await db.query(
      tableItems,
      columns:ItemFields.values,
      where: "${ItemFields.receiptId} = ?",
      whereArgs: [receiptId],
    );

    if (maps.isNotEmpty) {
      return LocalItems.fromJson(maps);
    } else {
      List<LocalItems>  items = [];
      return items;

      //throw Exception('ID $id not found');
    }
  }



/*
  Future<int> update(Items item) async {
    final db = await instance.database;

    return db.update(
      tableItems,
      item.toJson(),
      where: '${ItemFields.id} = ?',
      whereArgs: [item.id],
    );
  }
*/

  Future<int> delete(int receiptId) async {
    final db = await instance.database;

    return await db.delete(
      tableItems,
      where: "${ItemFields.receiptId} = ?",
      whereArgs: [receiptId],
    );
  }
  Future<int> deleteAll() async {
    final db = await instance.database;

    return await db.delete(
      tableItems,
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
