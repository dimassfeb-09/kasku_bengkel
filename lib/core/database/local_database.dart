import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('kasirku_bengkel.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // Inventory Table
    await db.execute('''
      CREATE TABLE inventory (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        type TEXT NOT NULL, -- part, labor
        sku TEXT,
        purchasePrice REAL NOT NULL,
        sellingPrice REAL NOT NULL,
        stock INTEGER NOT NULL,
        minStockLevel INTEGER NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // Customer Table
    await db.execute('''
      CREATE TABLE customers (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        phone TEXT NOT NULL UNIQUE,
        email TEXT,
        address TEXT,
        createdAt TEXT NOT NULL
      )
    ''');

    // Vehicle Table
    await db.execute('''
      CREATE TABLE vehicles (
        id TEXT PRIMARY KEY,
        plateNumber TEXT NOT NULL UNIQUE,
        customerId TEXT NOT NULL,
        type TEXT NOT NULL,
        brand TEXT,
        model TEXT,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (customerId) REFERENCES customers (id)
      )
    ''');

    // Service Order Table
    await db.execute('''
      CREATE TABLE service_orders (
        id TEXT PRIMARY KEY,
        vehicleId TEXT, -- Reference to Master Vehicle
        plateNumber TEXT NOT NULL,
        ownerName TEXT NOT NULL,
        ownerPhone TEXT NOT NULL,
        vehicleType TEXT NOT NULL,
        vehicleBrand TEXT,
        vehicleModel TEXT,
        complaint TEXT NOT NULL,
        mechanicName TEXT,
        status TEXT NOT NULL,
        items TEXT NOT NULL, -- JSON string
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        completedAt TEXT,
        readyAt TEXT,
        FOREIGN KEY (vehicleId) REFERENCES vehicles (id)
      )
    ''');

    // Payment Transaction Table
    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        serviceOrderId TEXT NOT NULL,
        paymentMethod TEXT NOT NULL,
        totalAmount REAL NOT NULL,
        amountPaid REAL NOT NULL,
        changeAmount REAL NOT NULL,
        transactionDate TEXT NOT NULL,
        FOREIGN KEY (serviceOrderId) REFERENCES service_orders (id)
      )
    ''');
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
