import 'package:flutter_test/flutter_test.dart';
import 'package:wellfastify/services/db_service.dart';

void main() {
  late DBService dbService;

  setUp(() async {
    dbService = DBService();
  });

  tearDown(() async {
    final db = await dbService.database;
    await db.delete('fasting');
  });

  test('Insert and retrieve mock fasting data', () async {
    // Insert random fasting data
    await dbService.insertRandomFastingData();

    // Retrieve and check the inserted data
    final db = await dbService.database;
    final fastingData = await db.query('fasting');

    expect(fastingData.length, 7); // There should be 7 entries
    for (var entry in fastingData) {
      //print(entry);
    }
  });
}
