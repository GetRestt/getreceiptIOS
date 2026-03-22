import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import '../model/local/withholding.dart';
import '../model/main_withhold_data.dart';

class WithholdingDatabase {
  static final WithholdingDatabase instance = WithholdingDatabase._init();

  static Database? _database;

  WithholdingDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    await deleteDB();
    _database = await _initDB('withholding.db');
    return _database!;
  }
  Future <void> deleteDB() async{
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "withholding.db");
    await deleteDatabase(path);
  }
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      password: "_jav.d/e.java",
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const textUnique = 'TEXT NOT NULL UNIQUE';
    const textTypeNull = 'TEXT';
    const doubleType = 'REAL NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE ${tableWithholding} (
      ${WithholdingFields.id} $idType,
      ${WithholdingFields.morNo} $textUnique,
      ${WithholdingFields.irn} $textTypeNull,
      ${WithholdingFields.rrn} $textType,
      ${WithholdingFields.systemNo} $textType,
      ${WithholdingFields.senderName} $textTypeNull,
      ${WithholdingFields.senderCity} $textTypeNull,
      ${WithholdingFields.senderWereda} $textTypeNull,
      ${WithholdingFields.senderAddress} $textTypeNull,
      ${WithholdingFields.senderTin} $textTypeNull,
      ${WithholdingFields.senderVat} $textTypeNull,
      ${WithholdingFields.receiverPhoneNo} $textTypeNull,
      ${WithholdingFields.receiverName} $textTypeNull,
      ${WithholdingFields.receiverTin} $textTypeNull,
      ${WithholdingFields.receiverAddress} $textTypeNull,
      ${WithholdingFields.receiverCity} $textTypeNull,
      ${WithholdingFields.type} $textType,
      ${WithholdingFields.preTax} $doubleType,
      ${WithholdingFields.withholdAmt} $doubleType,
      ${WithholdingFields.words} $textTypeNull,
      ${WithholdingFields.casher} $textType,
      ${WithholdingFields.title} $textTypeNull,
      ${WithholdingFields.qr} $textType,
      ${WithholdingFields.isNew} $integerType,
      ${WithholdingFields.time} $textType
    )
    ''');
  }

  // Insert a new record
  Future<LocalWithholding> create(LocalWithholding withholding) async {
    final db = await instance.database;
    final id = await db.insert(tableWithholding, withholding.toJson());
    return withholding.copy(id: id);
  }

  // Read all records
  Future<List<LocalWithholding>> readAll() async {
    final db = await instance.database;
    final maps = await db.query(tableWithholding, columns: WithholdingFields.values);

    if (maps.isNotEmpty) {
      return maps.map((e) => LocalWithholding.fromJson(e)).toList();
    } else {
      return [];
    }
  }
  Future<DateTime> getLatestDate() async {
    final db = await instance.database;
    const orderBy = '${WithholdingFields.time} DESC';
    final result = await db.query(tableWithholding, orderBy: orderBy);


    if (result.isNotEmpty) {
      return LocalWithholding.fromJson(result.first).createdTime;
    } else {
      throw Exception('result not found');
    }
  }
  Future<List<MainWithholdData>> readAllWithholdings() async {
    late List<MainWithholdData> _data;
    final db = await instance.database;

    final orderBy = '${WithholdingFields.time} DESC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(tableWithholding, orderBy: orderBy);
    _data = [];
    //return result.map((json) => LocalReceipt.fromJson(json)).toList();
    for(var rec in result.map((json) => LocalWithholding.fromJson(json)).toList()){

      MainWithholdData md = MainWithholdData.fromJson(LocalWithholding.mapAsNonSqlStructure(rec));
      _data.add(md);
    }
    return _data;
  }
  // Read record by mor_no
  Future<LocalWithholding?> readByMorNo(String morNo) async {
    final db = await instance.database;
    final maps = await db.query(
      tableWithholding,
      columns: WithholdingFields.values,
      where: "${WithholdingFields.morNo} = ?",
      whereArgs: [morNo],
    );

    if (maps.isNotEmpty) {
      return LocalWithholding.fromJson(maps.first);
    } else {
      return null;
    }
  }

  // Delete by mor_no
  Future<int> deleteMorNo(String morNo) async {
    final db = await instance.database;
    return await db.delete(
      tableWithholding,
      where: "${WithholdingFields.morNo} = ?",
      whereArgs: [morNo],
    );
  }
  Future<int> update(String morNo) async {
    final db = await instance.database;
    LocalWithholding? withhold= await readByMorNo(morNo);
    withhold?.isNew = 0;
    return db.update(
      tableWithholding,
      withhold!.toJson(),
      where: "${WithholdingFields.morNo} = ?",
      whereArgs: [morNo],
    );
  }
  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableWithholding,
      where: "${WithholdingFields.id} = ?",
      whereArgs: [id],
    );
  }
  // Delete all records
  Future<int> deleteAll() async {
    final db = await instance.database;
    return await db.delete(tableWithholding);
  }

  // Close database
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}