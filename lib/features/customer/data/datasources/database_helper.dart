import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_wind_surf_demo/features/customer/domain/models/customer.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('customers.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add new columns for version 2
      await db.execute('ALTER TABLE customers ADD COLUMN createTime TEXT');
      await db.execute('ALTER TABLE customers ADD COLUMN school TEXT');
      await db.execute('ALTER TABLE customers ADD COLUMN birthday TEXT');
      await db.execute('ALTER TABLE customers ADD COLUMN email TEXT');
      await db.execute('ALTER TABLE customers ADD COLUMN phone TEXT');
      
      // Set default createTime for existing records
      await db.execute(
        "UPDATE customers SET createTime = ? WHERE createTime IS NULL",
        [DateTime.now().toIso8601String()],
      );
    }
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE customers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        gender TEXT NOT NULL,
        age INTEGER NOT NULL,
        address TEXT NOT NULL,
        color TEXT NOT NULL,
        createTime TEXT,
        school TEXT,
        birthday TEXT,
        email TEXT,
        phone TEXT
      )
    ''');
  }

  Future<Customer> create(Customer customer) async {
    final db = await instance.database;
    final id = await db.insert('customers', customer.toMap());
    return customer.id == null ? Customer(
      id: id,
      name: customer.name,
      gender: customer.gender,
      age: customer.age,
      address: customer.address,
      color: customer.color,
      createTime: customer.createTime ?? DateTime.now(),
      school: customer.school,
      birthday: customer.birthday,
      email: customer.email,
      phone: customer.phone,
    ) : customer;
  }

  Future<List<Customer>> getAllCustomers() async {
    final db = await instance.database;
    final result = await db.query('customers');
    return result.map((json) => Customer.fromMap(json)).toList();
  }

  Future<Customer?> getCustomer(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Customer.fromMap(maps.first);
    }
    return null;
  }

  Future<int> update(Customer customer) async {
    final db = await instance.database;
    return db.update(
      'customers',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
