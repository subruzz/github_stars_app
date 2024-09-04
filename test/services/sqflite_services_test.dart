import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:github_starts_app/services/sqflite_services.dart';

import '../test_utils/data/test_data.dart';

void main() {
  // Setup sqflite_common_ffi for flutter test
  setUpAll(() {
    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory
    databaseFactory = databaseFactoryFfi;
  });

  group('DatabaseHelper Tests', () {
    late DatabaseHelper databaseHelper;
    late Database db;

    setUp(() async {
      databaseHelper = DatabaseHelper();
      db = await openDatabase(inMemoryDatabasePath, version: 1,
          onCreate: (db, version) async {
        // Create tables as needed by your DatabaseHelper
        await db.execute(
            'CREATE TABLE repositories (id INTEGER PRIMARY KEY, name TEXT)');
      });
    });

    test('deleteAllRepos removes all repositories from the database', () async {
      // Arrange
      final repos = [TestData.repo1, TestData.repo2];
      await databaseHelper.cacheRepositories(repos);

      // Act
      await databaseHelper.deleteAllRepos();

      // Assert
      final cachedRepos = await databaseHelper.getCachedRepositories(0);
      expect(cachedRepos, isEmpty);
    });

    test('getCachedRepositories retrieves repositories from the database',
        () async {
      // Arrange
      final repos = [TestData.repo1, TestData.repo2];
      await databaseHelper.cacheRepositories(repos);

      // Act
      final cachedRepos = await databaseHelper.getCachedRepositories(0);

      // Assert
      expect(cachedRepos, hasLength(2));
      expect(cachedRepos[0].name, TestData.repoName1);
      expect(cachedRepos[1].name, TestData.repoName2);
    });

    tearDown(() async {
      await db.close();
    });
  });
}
