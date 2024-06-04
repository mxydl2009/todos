import 'package:flutter/material.dart';
import 'package:todos/model/todo.dart';
import 'package:todos/utils/db_provider.dart';

enum TodoListChangeType {
  Delete,
  Insert,
  Update,
}

class TodoListChangeInfo {
  const TodoListChangeInfo({
    this.todoList = const <Todo>[],
    this.insertOrRemoveIndex = -1,
    this.type = TodoListChangeType.Update,
  });

  final int insertOrRemoveIndex;
  final List<Todo> todoList;
  final TodoListChangeType type;
}

const emptyTodoListChangeInfo = TodoListChangeInfo();

class TodoList extends ValueNotifier<TodoListChangeInfo> {
// class TodoList extends ChangeNotifier {
  final List<Todo> _todoList = [];
  // List<Todo> _todoList;
  late DbProvider _dbProvider;
  final String userKey;

  // TodoList(this._todoList) {
  //   _sort();
  // }
  TodoList(this.userKey) : super(emptyTodoListChangeInfo) {
    _dbProvider = DbProvider(userKey);
    _dbProvider.loadFromDataBase().then((List<Todo> todoList) async {
      if (todoList.isNotEmpty) {
        for (var e in todoList) {
          add(e);
        }
      }
      // syncWithNetwork();
    });
  }

  int get length => _todoList.length;
  List<Todo> get list => List.unmodifiable(_todoList);

  void add(Todo todo) {
    _todoList.add(todo);
    _sort();
    int index = _todoList.indexOf(todo);
    _dbProvider.add(todo);
    value = TodoListChangeInfo(
      insertOrRemoveIndex: index,
      type: TodoListChangeType.Insert,
      todoList: list,
    );
    // notifyListeners();
  }

  void remove(String id) {
    Todo todo = find(id);
    // if (todo == null) {
    //   assert(false, 'Todo with $id is not exist');
    //   return;
    // }
    int index = _todoList.indexOf(todo);
    List<Todo> clonedList = List.from(_todoList);
    _todoList.removeAt(index);
    _dbProvider.remove(todo);
    value = TodoListChangeInfo(
      insertOrRemoveIndex: index,
      type: TodoListChangeType.Delete,
      todoList: clonedList,
    );
    // notifyListeners();
  }

  void update(Todo todo) {
    _sort();
    _dbProvider.update(todo);
    value = TodoListChangeInfo(
      type: TodoListChangeType.Update,
      todoList: list,
    );
    notifyListeners();
  }

  Todo find(String id) {
    int index = _todoList.indexWhere((todo) => todo.id == id);
    return _todoList[index];
    // return index >= 0 ? _todoList[index] : null;
  }

  void _sort() {
    _todoList.sort((Todo a, Todo b) {
      if (!a.isFinished && b.isFinished) {
        return -1;
      }
      if (a.isFinished && !b.isFinished) {
        return 1;
      }
      if (a.isStar && !b.isStar) {
        return -1;
      }
      if (!a.isStar && b.isStar) {
        return 1;
      }
      if (a.priority.isHigher(b.priority)) {
        return -1;
      }
      if (b.priority.isHigher(a.priority)) {
        return 1;
      }
      int dateCompareResult = b.date.compareTo(a.date);
      if (dateCompareResult != 0) {
        return dateCompareResult;
      }
      return a.endTime.hour - b.endTime.hour;
    });

    // notifyListeners();
  }
}
