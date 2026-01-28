import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../models/cart.dart';
import '../models/customer.dart';
import '../models/order.dart';
import '../models/product.dart';

class DatabaseService {
  static Database? _database;
  static const String tableproduct = 'product';
  static const String tablecustomer = 'customer';
  static const String tableorder = 'order';
  static const String dbname = 'pos.db';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), dbname);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $tableproduct(
        id INTEGER PRIMARY KEY,
        name TEXT,
        price REAL,
        imageUrl TEXT,
        stock INTEGER
    ''');
    await db.execute('''
        CREATE TABLE $tablecustomer(
        id INTEGER PRIMARY KEY,
        name TEXT,
        email TEXT,
        phone TEXT
        )
''');
    await db.execute('''
        CREATE TABLE $tableorder(
        id INTEGER PRIMARY KEY,
        customerID INTEGER,
        items TEXT,
        total REAL,
        date TEXT
        )
''');

await db.insert(tableproduct, {
      'id': 1,
      'name': 'Coffee',
      'price': 4.99,
      'imageUrl': '',
      'stock': 100,
    });
    await db.insert(tableproduct, {
      'id': 2,
      'name': 'Sandwich',
      'price': 8.99,
      'imageUrl': '',
      'stock': 50,
    });
    await db.insert(tablecustomer, {
      'id': 1,
      'name': 'John Doe',
      'phone': '1234567890',
      'email': 'john@example.com',
    });

  }
}
