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
        endTime TEXT,
        fastingHours INTEGER,
        date TEXT
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

  //Get Total Fasts
  Future<int> getTotalFasts() async {
    final db = await database;
    print('getTotal');
    final result = await db.rawQuery('SELECT COUNT(*) as total FROM fasting');
    if (result.isNotEmpty && result.first['total'] != null) {
      return result.first['total'] as int;
    } else {
      return 0;
    }
  }

//Get Total Fasting time
  Future<int> getTotalFastingTime() async {
    final db = await database;
    print('getTotalTime');
    final result =
        await db.rawQuery('SELECT SUM(fastingHours) as total FROM fasting');
    if (result.isNotEmpty && result.first['total'] != null) {
      return result.first['total'] as int;
    } else {
      return 0;
    }
  }

// Longest Fast
  Future<int> getLongestFast() async {
    final db = await database;
    print('getLongest');
    final result =
        await db.rawQuery('SELECT MAX(fastingHours) as longest FROM fasting');
    if (result.isNotEmpty && result.first['longest'] != null) {
      return result.first['longest'] as int;
    } else {
      return 0;
    }
  }

  //Get Average Fasts
  Future<int> getAverageFast() async {
    final db = await database;
    int averageInt = 0;
    final result =
        await db.rawQuery('SELECT AVG(fastingHours) as total FROM fasting');

    if (result.isNotEmpty && result.first['total'] != null) {
      averageInt = (result.first['total'] as double).toInt();
      return averageInt;
    } else {
      return averageInt;
    }
  }

  //Get Max Streak Fasts
  Future<int> getMaxStreak() async {
    final db = await database;
    print('getmaxstreak');
    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT DISTINCT date FROM fasting
    ORDER BY date ASC
  ''');
    if (result.isEmpty) {
      return 0;
    }
    int maxStreak = 1;
    int currentStreak = 1;
    DateTime? previousDate = DateTime.parse(result.first['date']);
    for (int i = 1; i < result.length; i++) {
      final DateTime currentDate = DateTime.parse(result[i]['date']);
      if (currentDate.difference(previousDate!).inDays == 1) {
        currentStreak++;
        maxStreak = currentStreak > maxStreak ? currentStreak : maxStreak;
      } else {
        currentStreak = 1;
      }
      previousDate = currentDate;
    }
    return maxStreak;
  }

  //Get Current Streak
  Future<int> getCurrentStreak() async {
    final db = await database;
    print('getcurrentstreak');
    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT DISTINCT date FROM fasting
    ORDER BY date ASC
  ''');
    if (result.isEmpty) {
      return 0; // No data, no streak
    }
    int currentStreak = 1;
    DateTime? previousDate = DateTime.parse(result.last['date']);
    for (int i = result.length - 2; i >= 0; i--) {
      final DateTime currentDate = DateTime.parse(result[i]['date']);
      // Check if the current date is consecutive with the previous date
      if (previousDate!.difference(currentDate).inDays == 1) {
        currentStreak++;
        previousDate = currentDate; // Move the previous date back one day
      } else {
        break; // Stop counting if the dates are not consecutive
      }
    }
    // Check if the streak includes today
    if (previousDate != null &&
        DateTime.now().difference(previousDate).inDays > 1) {
      currentStreak =
          0; // No streak if the last fasting date is not yesterday or today
    }
    return currentStreak;
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
  Future<int> insertTimer(TimerData timer) async {
    final db = await database;
    return await db.insert('timer', timer.toMap());
  }

  //Get Timer
  Future<TimerData?> getTimer() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('timer', limit: 1);
    if (maps.isNotEmpty) {
      return TimerData.fromMap(maps.first);
    }
    return null;
  }

  //Update Timer
  Future<int> updateTimerData({required int newDuration}) async {
    final db = await database;
    return await db.update(
      'timer',
      {
        'duration': newDuration,
      },
      where: 'id = ?', // Condition to update only the first row
      whereArgs: [1], // ID of the first row
    );
  }

  //Delete Timer
  Future<int> deleteTimerData() async {
    final db = await database;
    return await db.delete('timer');
  }
}
