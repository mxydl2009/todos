import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todos/const/route_argument.dart';
import 'package:todos/model/todo.dart';
import 'package:todos/routes.dart';
import 'package:todos/components/deleteTodoDialog.dart';
import 'package:todos/model/todoList.dart';
import 'package:provider/provider.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  TodoListPageState createState() => TodoListPageState();
}

class TodoListPageState extends State<TodoListPage> {
  late TodoList todoList;
  GlobalKey<AnimatedListState> animatedListKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    // 从父页面获取数据
    todoList = Provider.of<TodoList>(context, listen: false);
    // debugPrint(todoList.toString());
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // setState(() {
    todoList = Provider.of(context, listen: false);
    debugPrint('todoList page todoList is ${todoList.length}');
    // });
  }

  void addTodo(Todo todo) {
    // setState(() {
    //   todoList.add(todo);
    // });
    // final todoList = Provider.of<TodoList>(context, listen: false);
    todoList.add(todo);
    int index = todoList.list.indexOf(todo);
    animatedListKey.currentState?.insertItem(index);
  }

  void removeTodo(Todo todo) async {
    // final todoList = Provider.of<TodoList>(context, listen: false);
    bool result = await showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return DeleteTodoDialog(todo: todo);
        });
    if (result) {
      int index = todoList.list.indexOf(todo);
      todoList.remove(todo.id);
      animatedListKey.currentState?.removeItem(index,
          (BuildContext context, Animation<double> animation) {
        return SizeTransition(
            sizeFactor: animation, child: TodoItem(todo: todo));
      });
    }
  }

  Widget _buildContent(TodoList todoList) {
    if (todoList.isNotEmpty()) {
      return AnimatedList(
          key: animatedListKey,
          initialItemCount: todoList.length,
          itemBuilder:
              (BuildContext context, int index, Animation<double> animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: TodoItem(
                todo: todoList.list[index],
                onTap: (Todo todo) async {
                  // 跳转到修改待办事项页面，修改完成后更新todoList;
                  // 这里居然可以使用await来等待页面返回，没见过这种操作;
                  await Navigator.of(context).pushNamed(TODO_EDIT_PAGE_URL,
                      arguments: EditTodoPageArgument(
                        openType: OpenType.Preview,
                        todo: todo,
                      ));
                  setState(() {
                    todoList.update(todo);
                  });
                },
                onFinished: (Todo todo) {
                  setState(() {
                    todo.isFinished = !todo.isFinished;
                    todoList.update(todo);
                  });
                },
                onStar: (Todo todo) {
                  setState(() {
                    todo.isStar = !todo.isStar;
                    todoList.update(todo);
                  });
                },
                // onLongPress: (Todo todo) async {
                //   debugPrint('onLongPress $todo');
                //   bool result = await showCupertinoDialog(
                //       context: context,
                //       builder: (BuildContext context) {
                //         return DeleteTodoDialog(todo: todo);
                //       });
                //   if (result) {
                //     setState(() {
                //       todoList.remove(todo.id);
                //     });
                //   }
                // },
                onLongPress: removeTodo,
              ),
            );
          });
    }
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            "暂无数据",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todoList = context.watch<TodoList>();
    return Scaffold(
        appBar:
            AppBar(automaticallyImplyLeading: false, title: const Text('待办清单')),
        body: _buildContent(todoList));
  }
}

typedef TodoEventCallback = Function(Todo todo);

class TodoItem extends StatelessWidget {
  final Todo? todo;
  final TodoEventCallback? onStar;
  final TodoEventCallback? onFinished;
  final TodoEventCallback? onTap;
  final TodoEventCallback? onLongPress;

  const TodoItem(
      {super.key,
      this.todo,
      this.onStar,
      this.onFinished,
      this.onLongPress,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Opacity(
        opacity: todo!.isFinished ? 0.6 : 1.0,
        child: GestureDetector(
          onTap: () {
            if (onTap != null) {
              onTap!(todo!);
            }
          },
          onLongPress: () {
            if (onLongPress != null) {
              onLongPress!(todo!);
            }
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    left: BorderSide(width: 2, color: todo!.priority.color))),
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
            height: 110,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => onFinished!(todo!),
                          child: Image.asset(
                              todo!.isFinished
                                  ? 'assets/images/rect_selected.png'
                                  : 'assets/images/rect.png',
                              width: 25,
                              height: 25),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Text(todo!.title),
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () => onStar!(todo!),
                      child: Container(
                        child: Image.asset(
                          todo!.isStar
                              ? 'assets/images/star.png'
                              : 'assets/images/star_normal.png',
                          width: 25,
                          height: 25,
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/group.png',
                      width: 25,
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(todo?.timeString ?? ''),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
