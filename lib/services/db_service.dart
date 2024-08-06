import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:wellfastify/models/fasting_model.dart';
import 'package:wellfastify/models/timer_model.dart';
import 'package:wellfastify/models/weight._model.dart';

class DBService {
  static final DBService _instance = DBService._internal();
  factory DBService() => _instance;

  static Database? _database;

  DBService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'fasting_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE fasting (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        startTime TEXT,
        fastingHours TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE weight (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        weight REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE timer (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        startTime TEXT,
        duration INTEGER
      )
    ''');
  }

  // CRUD methods for Fasting
  //Insert Fasting
  Future<int> insertFasting(Fasting fasting) async {
    final db = await database;
    return await db.insert('fasting', fasting.toMap());
  }

  //Get all Fastings
  Future<List<Fasting>> getFastings() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('fasting');
    return List.generate(maps.length, (i) {
      return Fasting.fromMap(maps[i]);
    });
  }

  //Delete Fasting
  Future<int> deleteFasting(int id) async {
    final db = await database;
    return await db.delete('fasting', where: 'id = ?', whereArgs: [id]);
  }

  //Delete all Fastings
  Future<int> deleteAllFastings() async {
    final db = await database;
    return await db.delete('fasting');
  }

  // CRUD methods for Weight
  //Insert Weight
  Future<int> insertWeight(Weight weight) async {
    final db = await database;
    return await db.insert('weight', weight.toMap());
  }

  //Get all Weights
  Future<List<Weight>> getWeights() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('weight');
    return List.generate(maps.length, (i) {
      return Weight.fromMap(maps[i]);
    });
  }

  //Delete Weight
  Future<int> deleteWeight(int id) async {
    final db = await database;
    return await db.delete('weight', where: 'id = ?', whereArgs: [id]);
  }

  //Delete all Weights
  Future<int> deleteAllWeights() async {
    final db = await database;
    return await db.delete('weight');
  }

  // CRUD methods for Timer
  //Insert Timer
  Future<int> insertTimer(Timer timer) async {
    final db = await database;
    return await db.insert('timer', timer.toMap());
  }

  //Get Timer
  Future<Timer?> getTimer() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('timer', limit: 1);
    if (maps.isNotEmpty) {
      return Timer.fromMap(maps.first);
    }
    return null;
  }

  //Delete Timer
  Future<int> deleteTimerData() async {
    final db = await database;
    return await db.delete('timer');
  }
}
