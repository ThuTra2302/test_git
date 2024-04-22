import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'history_trip.dart';

class DatabaseService {
  // Singleton pattern
  static final DatabaseService _databaseService = DatabaseService._internal();

  factory DatabaseService() => _databaseService;

  DatabaseService._internal();

  static const _databaseName = 'history_trip.db';
  static const _historyTripTable = 'history_trip_table';

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE $_historyTripTable(
            addressFrom NVARCHAR(100) NOT NULL, 
            addressTo   NVARCHAR(100) NOT NULL, 
            isFavorite INTEGER,
            PRIMARY KEY (addressFrom, addressTo)
      )''');
  }

  Future<void> insert(HistoryTrip historyTrip) async {
    final db = await _databaseService.database;

    await db.insert(
      _historyTripTable,
      historyTrip.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the breeds from the breeds table.
  Future<List<HistoryTrip>> getAll() async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Query the table for all the Breeds.
    final List<Map<String, dynamic>> maps = await db.query(_historyTripTable);

    return List.generate(maps.length, (index) => HistoryTrip.fromMap(maps[index]));
  }

  Future<List<HistoryTrip>> getAllFavorite() async {
    final db = await _databaseService.database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
        SELECT * FROM $_historyTripTable where isFavorite = 1
    ''');

    return List.generate(maps.length, (index) => HistoryTrip.fromMap(maps[index]));
  }

  Future<List<String>> getAllAddressFrom() async {
    final db = await _databaseService.database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
        SELECT addressFrom FROM $_historyTripTable
    ''');

    return List.generate(maps.length, (index) => maps[index]['addressFrom'].toString());
  }

  Future<List<String>> getAllAddressTo() async {
    final db = await _databaseService.database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
        SELECT addressTo FROM $_historyTripTable
    ''');

    return List.generate(maps.length, (index) => maps[index]['addressTo'].toString());
  }

  Future<int> updateFavorite(HistoryTrip historyTrip) async {
    final db = await _databaseService.database;

    return db.rawUpdate(
      '''UPDATE $_historyTripTable
        SET isFavorite = ?
        WHERE addressFrom = ? AND addressTo = ?''',
      [1, historyTrip.addressFrom, historyTrip.addressTo],
    );
  }

  Future<int> updateNotFavorite(HistoryTrip historyTrip) async {
    final db = await _databaseService.database;

    return db.rawUpdate(
      '''UPDATE $_historyTripTable
        SET isFavorite = ?
        WHERE addressFrom = ? AND addressTo = ?''',
      [0, historyTrip.addressFrom, historyTrip.addressTo],
    );
  }

  Future<HistoryTrip> getItem(String addressFrom, String addressTo) async {
    final db = await _databaseService.database;

    final List<Map<String, dynamic>> map = await db
        .rawQuery('''select * from $_historyTripTable where addressFrom = ? AND addressTo = ?''', [addressFrom, addressTo]);

    return HistoryTrip.fromMap(map[0]);
  }
}
