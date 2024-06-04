import 'package:todos/model/todo.dart';

class RegisterPageArgument {
  final String className;
  final String url;

  RegisterPageArgument(this.className, this.url);
}

enum OpenType { Add, Edit, Preview }

class EditTodoPageArgument {
  final OpenType openType;
  final Todo? todo;

  EditTodoPageArgument({this.openType = OpenType.Preview, this.todo});
}

class TodoEntryArgument {
  final String userKey;

  TodoEntryArgument(this.userKey);
}
