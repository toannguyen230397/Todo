import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/todo.dart';
import 'package:path/path.dart';

class TodoDataBase {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'todo_database.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE todo(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            desc TEXT,
            date TEXT,
            notiID INTEGER,
            isDone INTEGER
          )
          ''');
    });
  }
  
  Future<void> AddTaskDatabase(Todo task) async {
    final Database db = await database;
    await db.insert(
      'todo',
      {'id': task.id, 'title': task.title, 'desc': task.desc, 'date': task.date, 'notiID': task.notiID, 'isDone': task.isDone},
    );
  }

  Future<void> DeleteTaskDatabase(Todo task) async {
    final Database db = await database;
    await db.delete(
      'todo',
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> UpdateTaskDatabase(Todo task) async {
    final Database db = await database;
    await db.update(
      'todo',
      {'title': task.title, 'desc': task.desc},
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> UpdateDoneTaskDatabase(Todo task) async {
    final Database db = await database;
    await db.update(
      'todo',
      {'isDone': 1},
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<List<Todo>> GetAllDataFromDatabase() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('todo');
    return List.generate(maps.length, (i) {
      return Todo(
        id: maps[i]['id'],
        title: maps[i]['title'],
        desc: maps[i]['desc'],
        date: maps[i]['date'],
        notiID: maps[i]['notiID'],
        isDone: maps[i]['isDone'],
      );
    });
  }

  Future<void> deleteDatabase() async {
    String path = join(await getDatabasesPath(), 'todo_database.db');
    databaseFactory.deleteDatabase(path);
  }
}