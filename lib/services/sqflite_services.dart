
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/repo_model.dart';

/// A helper class for managing SQLite database operations related to repository data caching.
/// This class follows the Singleton pattern to ensure a single instance of the database throughout the application lifecycle.
class DatabaseHelper {
  // Singleton pattern to ensure only one instance of DatabaseHelper exists
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  /// Factory constructor to return the singleton instance of DatabaseHelper.
  factory DatabaseHelper() => _instance;

  // Private named constructor for internal instantiation of the singleton instance
  DatabaseHelper._internal();

  // SQLite database instance
  static Database? _database;

  /// Returns the existing database instance, or initializes it if it's not already available.
  /// This getter ensures the database is only opened once and reused across the application.
  Future<Database> get database async {
    // Return the existing database instance if it has already been created
    if (_database != null) return _database!;
    
    // Otherwise, initialize and return the database instance
    _database = await _initDatabase();
    return _database!;
  }

  /// Initializes the SQLite database by setting up the database path and creating the necessary tables.
  /// 
  /// This method is called once when the database is first accessed.
  /// 
  /// Returns an instance of the opened [Database].
  Future<Database> _initDatabase() async {
    // Get the path to the database directory
    final dbPath = await getDatabasesPath();
    
    // Open the database and create the 'repos' table if it doesn't already exist
    return await openDatabase(
      join(dbPath, 'repos.db'), // Define the database file name
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE repos('
          'id INTEGER PRIMARY KEY, '
          'name TEXT, '
          'ownerName TEXT, '
          'ownerAvatarUrl TEXT, '
          'stars INTEGER, '
          'description TEXT'
          ')', // SQL command to create the 'repos' table
        );
      },
      version: 1, // Set the database version
    );
  }

  /// Caches a list of repositories into the local SQLite database.
  /// 
  /// [repos] is the list of repositories to be cached.
  /// 
  /// If [isClear] is set to `true`, the existing records in the 'repos' table will be cleared before inserting new data.
  /// 
  /// This method uses a batch operation to ensure that the database updates are efficient and atomic.
  Future<void> cacheRepositories(List<RepoModel> repos, {bool isClear = false}) async {
    // Get the database instance
    final db = await database;
    
    // Start a batch operation
    final batch = db.batch();

    // Clear existing records if isClear is true
    if (isClear) {
      batch.delete('repos');
    }

    // Insert each repository into the 'repos' table
    for (var repo in repos) {
      batch.insert(
        'repos',
        repo.toMap(), // Convert the RepoModel instance to a Map
        conflictAlgorithm: ConflictAlgorithm.replace, // Replace existing data with the same primary key
      );
    }

    // Commit the batch operation to save changes
    await batch.commit(noResult: true);
  }

  /// Retrieves cached repositories from the SQLite database.
  /// 
  /// The repositories are returned sorted by their star count in descending order.
  /// 
  /// [offset] is currently unused but could be implemented for pagination in future.
  /// 
  /// Returns a list of [RepoModel] instances.
  Future<List<RepoModel>> getCachedRepositories(int offset) async {
    // Get the database instance
    final db = await database;
    
    // Query the database and order the results by the 'stars' field in descending order
    final List<Map<String, dynamic>> maps = await db.query(
      'repos',
      orderBy: 'stars DESC',
    );

    // Convert the List<Map<String, dynamic>> to a List<RepoModel>
    return List.generate(maps.length, (i) {
      return RepoModel.fromMap(maps[i]);
    });
  }

  /// Deletes all records from the 'repos' table in the SQLite database.
  /// 
  /// This method is useful for clearing the cache or resetting the database.
  Future<void> deleteAllRepos() async {
    // Get the database instance
    final db = await database;
    
    // Delete all records from the 'repos' table
    await db.delete('repos');
  }
}
