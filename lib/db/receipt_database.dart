
import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../model/local/items.dart';
import '../model/local/receipt.dart';
import '../model/main_data.dart';
import 'items_database.dart';

class ReceiptDatabase {
  static final ReceiptDatabase instance = ReceiptDatabase._init();

  static Database? _database;

  ReceiptDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('receipts.db');
    return _database!;
  }
  Future <void> deleteDB() async{
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "receipts.db");
    await deleteDatabase(path);
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
    const textTypeNull = 'TEXT';
    const doubleTypeNull = 'REAL';

    await db.execute('''
CREATE TABLE $tableReceipts ( 
  ${ReceiptFields.id} $idType, 
  ${ReceiptFields.userPhoneNo} $textType,
  ${ReceiptFields.senderName} $textType,
  ${ReceiptFields.senderContactNo} $textType,
  ${ReceiptFields.senderTinNo} $textType,
  ${ReceiptFields.senderAddress} $textType,
  ${ReceiptFields.billNo} $textType,
  ${ReceiptFields.operatorName} $textTypeNull,
  ${ReceiptFields.paymentMode} $textType,
  ${ReceiptFields.store} $textTypeNull,
  ${ReceiptFields.total} $doubleType,
  ${ReceiptFields.scAmt} $doubleType,
  ${ReceiptFields.tax} $doubleType,
  ${ReceiptFields.grandTotal} $doubleType,
  ${ReceiptFields.barCode} $textTypeNull,
  ${ReceiptFields.isNew} $integerType,
  ${ReceiptFields.status} $textTypeNull,
  ${ReceiptFields.lotteryFee} $doubleType,
  ${ReceiptFields.buyerTinNo} $textTypeNull,
  ${ReceiptFields.time} $textType,

  -- NEW FIELDS
  ${ReceiptFields.irn} $textTypeNull,
  ${ReceiptFields.itemType} $textTypeNull,
  ${ReceiptFields.withholdAmt} $doubleTypeNull,
  ${ReceiptFields.type} $textTypeNull,
  ${ReceiptFields.qr} $textTypeNull,
  ${ReceiptFields.discount} $doubleTypeNull,
  ${ReceiptFields.buyerName} $textTypeNull,
  ${ReceiptFields.invoiceLable} $textTypeNull,
  ${ReceiptFields.salesType} $textTypeNull,
  ${ReceiptFields.systemNumber} $textTypeNull,
  ${ReceiptFields.senderVatNo} $textTypeNull,
  ${ReceiptFields.senderCity} $textTypeNull,
  ${ReceiptFields.amountInWords} $textTypeNull,
  ${ReceiptFields.documentNo} $textTypeNull,
  ${ReceiptFields.referenceIrn} $textTypeNull,
  ${ReceiptFields.invoiceLableAmharic} $textTypeNull,
  ${ReceiptFields.receiptLable} $textTypeNull,
  ${ReceiptFields.qrReceipt} $textTypeNull,
  ${ReceiptFields.receiptPayment} $textTypeNull
)
''');
  }

  Future<LocalReceipt> create(LocalReceipt receipt) async {
    final db = await instance.database;

    // final json = note.toJson();
    // final columns =
    //     '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tableReceipts, receipt.toJson());
    return receipt.copy(id: id);
  }
  Future<LocalReceipt> readReceipt(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableReceipts,
      columns:ReceiptFields.values,
      where: "${ReceiptFields.id} = ?",
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return LocalReceipt.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }
  Future<DateTime> getLatestDate() async {
    final db = await instance.database;
    const orderBy = '${ReceiptFields.time} DESC';
    final result = await db.query(tableReceipts, orderBy: orderBy);


    if (result.isNotEmpty) {
      return LocalReceipt.fromJson(result.first).createdTime;
    } else {
      throw Exception('result not found');
    }
  }

  Future<List<MainData>> readAllReceipts() async {
    late List<MainData> _data;
    late List<LocalItems> _items;
    final db = await instance.database;

    final orderBy = '${ReceiptFields.time} DESC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(tableReceipts, orderBy: orderBy);
    _data = [];
    //return result.map((json) => LocalReceipt.fromJson(json)).toList();
    for(var rec in result.map((json) => LocalReceipt.fromJson(json)).toList()){
      _items =[];
      _items=await ItemsDatabase.instance.readItems(rec.id!);
      MainData md = MainData.fromJson(LocalReceipt.mapAsNonSqlStructure(rec, _items));

      _data.add(md);
    }
    return _data;
  }


/*  Future<int> update(Receipt receipt) async {
    final db = await instance.database;

    return db.update(
      tableReceipts,
      receipt.toJson(),
      where: '${ReceiptFields.id} = ?',
      whereArgs: [receipt.id],
    );
  }*/
  Future<int> update(int id) async {
    final db = await instance.database;
    LocalReceipt receipt= await readReceipt(id);
    receipt.isNew = 0;
    return db.update(
      tableReceipts,
      receipt.toJson(),
      where: "${ReceiptFields.id} = ?",
      whereArgs: [id],
    );
  }
  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableReceipts,
      where: "${ReceiptFields.id} = ?",
      whereArgs: [id],
    );
  }
  Future<int> deleteAll() async {
    final db = await instance.database;

    return await db.delete(
      tableReceipts,
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
