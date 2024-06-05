import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todos/model/todo.dart';

const String DB_NAME = 'todo_list.db';
const String TABLE_NAME = 'todo_list';
const String CREATE_TABLE_SQL = '''
create table $TABLE_NAME (
  $ID text primary key,
  $TITLE text,
  $DESCRIPTION text,
  $DATE text,
  $START_TIME text,
  $END_TIME text,
  $PRIORITY integer,
  $IS_FINISHED integer,
  $IS_STAR integer
)
''';
const String EDIT_TIME_KEY = 'todo_list_edit_timestamp';

class DbProvider {
  DbProvider(this._dbKey);

  Database? _database;
  SharedPreferences? _sharedPreferences;
  final String _dbKey;
  DateTime _editTime = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime get editTime => _editTime;

  String get editTimeKey => '$EDIT_TIME_KEY-$_dbKey';

  Future<List<Todo>> loadFromDataBase() async {
    await _initDataBase();
    if (_sharedPreferences!.containsKey(editTimeKey)) {
      int? editTime = _sharedPreferences!.getInt(editTimeKey);
      if (editTime != null) {
        _editTime = DateTime.fromMillisecondsSinceEpoch(
          editTime,
        );
      }
    }
    List<Map<String, dynamic>> dbRecords = await _database!.query(TABLE_NAME);
    print('dbRecords: $dbRecords, length is ${dbRecords.length}');
    return dbRecords.map((item) => Todo.fromMap(item)).toList();
  }

  Future<int> add(Todo todo) async {
    _updateEditTime();
    return _database!.insert(
      TABLE_NAME,
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> remove(Todo todo) async {
    _updateEditTime();
    return _database!.delete(
      TABLE_NAME,
      where: '$ID = ?',
      whereArgs: [todo.id],
    );
  }

  Future<int> removeAll() async {
    _updateEditTime();
    return _database!.delete(TABLE_NAME);
  }

  Future<int> update(Todo todo) async {
    _updateEditTime();
    return _database!.update(
      TABLE_NAME,
      todo.toMap(),
      where: '$ID = ?',
      whereArgs: [todo.id],
    );
  }

  void _updateEditTime() {
    _editTime = DateTime.now();
    _sharedPreferences!.setInt(editTimeKey, _editTime.millisecondsSinceEpoch);
  }

  Future<void> _initDataBase() async {
    _database ??= await openDatabase(
      '${_dbKey}_$DB_NAME',
      version: 1,
      onCreate: (Database database, int version) async {
        await database.execute(CREATE_TABLE_SQL);
      },
    );
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }
}
