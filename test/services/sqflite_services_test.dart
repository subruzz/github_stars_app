import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:github_starts_app/services/sqflite_services.dart';
import '../test_utils/data/test_data.dart';

// The main function for test setup and execution
void main() {
  // Setup sqflite_common_ffi for Flutter test
  setUpAll(() {
    // Initialize the sqflite FFI library for Flutter tests
    sqfliteFfiInit();

    // Change the default database factory to use FFI
    databaseFactory = databaseFactoryFfi;
  });

  group('DatabaseHelper Tests', () {
    // Declare the DatabaseHelper and Database variables
    late DatabaseHelper databaseHelper;
    late Database db;

    // This method runs before each test
    setUp(() async {
      // Instantiate the DatabaseHelper
      databaseHelper = DatabaseHelper();

      // Open an in-memory database for testing
      db = await openDatabase(
        inMemoryDatabasePath,
        version: 1,
        onCreate: (db, version) async {
          // Create the necessary tables for the tests
          await db.execute(
            'CREATE TABLE repos('
            'id INTEGER PRIMARY KEY, '
            'name TEXT, '
            'ownerName TEXT, '
            'ownerAvatarUrl TEXT, '
            'stars INTEGER, '
            'description TEXT'
            ')',
          );
        },
      );
    });

    // Test: Ensures that all repositories are removed from the database
    test('deleteAllRepos removes all repositories from the database', () async {
      // Arrange: Add test repositories to the database
      final repos = [TestData.repo1, TestData.repo2];
      await databaseHelper.cacheRepositories(repos);

      // Act: Delete all repositories
      await databaseHelper.deleteAllRepos();

      // Assert: Verify that the database is empty
      final cachedRepos = await databaseHelper.getCachedRepositories(0);
      expect(cachedRepos, isEmpty);
    });

    // Test: Ensures that cached repositories are retrieved correctly
    test('getCachedRepositories retrieves repositories from the database',
        () async {
      // Arrange: Add test repositories to the database
      final repos = [TestData.repo1, TestData.repo2];
      await databaseHelper.cacheRepositories(repos);

      // Act: Retrieve cached repositories
      final cachedRepos = await databaseHelper.getCachedRepositories(0);

      // Assert: Verify that the retrieved repositories match the expected results
      expect(cachedRepos, hasLength(2));
      expect(cachedRepos[0].name, TestData.repoName1);
      expect(cachedRepos[1].name, TestData.repoName2);
    });

    // This method runs after each test
    tearDown(() async {
      // Close the in-memory database after each test
      await db.close();
    });
  });
}
