import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/todo_model.dart';
@lazySingleton
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'todo_database.db');
    return await openDatabase(
      path,
      version: 6,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
       CREATE TABLE todos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      todo TEXT NOT NULL,
      completed INTEGER DEFAULT 0,
      userId INTEGER NOT NULL
    )
    ''');
  }

  // Insert a new ToDo item
  Future<int> insertTodo(Todo todo) async {
    final db = await database;

    // Check if the id already exists in the database
    List<Map<String, dynamic>> result = await db.query(
      'todos',
      where: 'id = ?',
      whereArgs: [todo.id],
    );

    if (result.isNotEmpty) {
      // If the ID exists, insert without providing an ID to let auto-increment handle it
      Map<String, dynamic> todoMap = todo.toMap();
      todoMap.remove('id'); // Remove the ID so SQLite can auto-generate it

      return await db.insert('todos', todoMap);
    } else {
      // If the ID does not exist, insert with the provided ID
      return await db.insert('todos', todo.toMap());
    }

  }

  // Insert a list of ToDo items in a batch operation
  Future<void> insertTodos(List<Todo> todos) async {
    final db = await database;
    Batch batch = db.batch(); // Create a batch

    // Add all insert operations to the batch
    for (var todo in todos) {
      batch.insert('todos', todo.toMap());
    }

    // Commit the batch (execute all operations in the batch)
    await batch.commit(noResult: true); // noResult: true means we don't need individual insert results
  }


  // Delete a ToDo item by its id
  Future<int> deleteTodoById(int todoId) async {
    final db = await database;
    return await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [todoId],
    );
  }

  // Update a ToDo item
  Future<int> updateTodoById(Todo todo) async {
    final db = await database;
    return await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  // Get a list of ToDo items with pagination
  Future<List<Todo>> getTodosWithPagination(int limit, int offset) async {
    final db = await database;

    // Query the todos table with limit and offset for pagination
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      limit: limit,
      offset: offset,
    );

    // Convert the list of maps into a list of ToDo objects
    return List.generate(maps.length, (i) {
      return Todo.fromMap(maps[i]);
    });
  }
}
