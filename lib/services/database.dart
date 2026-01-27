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
    return await openDatabase(path, version: 1);
  }
}
