import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../model/local/account.dart';

class AccountsDatabase {
  static final AccountsDatabase instance = AccountsDatabase._init();

  static Database? _database;

  AccountsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('accounts.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, password: "_jav.d/e.java", onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const textUnique = 'TEXT NOT NULL UNIQUE';

//  ${AccountFields.address} $textType,
    await db.execute('''
CREATE TABLE $tableAccounts ( 
  ${AccountFields.id} $idType,
  ${AccountFields.uid} $textType, 
  ${AccountFields.orgName} $textType,
  ${AccountFields.firstName} $textType,
  ${AccountFields.lastName} $textType,
  ${AccountFields.taxCenter} $textType,
  ${AccountFields.phoneNo} $textType,
  ${AccountFields.tinNo} $textType,
  ${AccountFields.vatNo} $textType,
  ${AccountFields.time} $textType
  )
''');
  }

  Future<Account> create(Account account) async {
    final db = await instance.database;

    // final json = note.toJson();
    // final columns =
    //     '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tableAccounts, account.toJson());
    return account.copy(id: id);
  }

  Future<Account> readAccount() async {
    final db = await instance.database;

    final maps = await db.query(
      tableAccounts,
      columns:AccountFields.values,
    );

    if (maps.isNotEmpty) {
      return Account.fromJson(maps.first);
    } else {
      return Account(
          id: 0,
          uid:"",
          orgName: "",
          firstName: "",
          lastName: "",
          taxCenter: "",
          phoneNo: "",
          //address: "",
          tinNo: "",
          vatNo: "",
          createdTime: DateTime.now()
      );

      //throw Exception('User not found');
    }
  }


  Future<int> update(Account account) async {
    final db = await instance.database;

    return db.update(
      tableAccounts,
      account.toJson(),
      where: "${AccountFields.id} = ?",
      whereArgs: [account.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableAccounts,
      where: "${AccountFields.id} = ?",
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
