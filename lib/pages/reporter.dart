import 'package:flutter/material.dart';
import 'package:todos/components/scroll_option_view.dart';
import 'package:todos/const/route_argument.dart';
import 'package:todos/routes.dart';
import 'package:todos/model/todo.dart';
import 'package:todos/model/todoList.dart';
import 'package:provider/provider.dart';

class ReporterPage extends StatefulWidget {
  const ReporterPage({super.key});

  @override
  _ReporterPageState createState() => _ReporterPageState();
}

class _ReporterPageState extends State<ReporterPage> {
  late TodoList _todoList;

  int _finishedTodoCount = 0;
  int _delayedTodoCount = 0;

  final List<Todo> _todosOfThisMonth = [];

  int currentMonth = 1;

  @override
  void initState() {
    super.initState();
    _todoList = context.read<TodoList>();
    _initTodosOfThisMonth();
    _todoList.addListener(_updateData);
  }

  @override
  void dispose() {
    _todoList.removeListener(_updateData);
    super.dispose();
  }

  void _reset() {
    _finishedTodoCount = 0;
    _delayedTodoCount = 0;
    _todosOfThisMonth.clear();
  }

  /// month: [1..12]
  void _initTodosOfThisMonth() {
    for (var todo in _todoList.list) {
      if (todo.date.month == currentMonth) {
        _todosOfThisMonth.add(todo);
        TodoStatus status = todo.status;
        if (status == TodoStatus.finished) {
          _finishedTodoCount += 1;
        }
        if (status == TodoStatus.delay) {
          _delayedTodoCount += 1;
        }
      }
    }
  }

  void _updateData() {
    setState(() {
      _reset();
      _initTodosOfThisMonth();
    });
  }

  void _onTap(Todo todo) async {
    await Navigator.of(context).pushNamed(TODO_EDIT_PAGE_URL,
        arguments: EditTodoPageArgument(
          openType: OpenType.Preview,
          todo: todo,
        ));
    _todoList.update(todo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('任务回顾'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 60,
            child: ScrollOptionView(
              options: const [
                '1月',
                '2月',
                '3月',
                '4月',
                '5月',
                '6月',
                '7月',
                '8月',
                '9月',
                '10月',
                '11月',
                '12月',
              ],
              onOptionChanged: (context, option, index) {
                setState(() {
                  currentMonth = index + 1;
                  _reset();
                  _initTodosOfThisMonth();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: _buildAllTodoStatusArea(),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: _buildColouredStripeArea(),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                children: <Widget>[
                  Expanded(flex: 1, child: _buildTodoListArea()),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAllTodoStatusArea() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _buildTodoStatusView(TodoStatus.finished, _finishedTodoCount),
        _buildTodoStatusView(TodoStatus.delay, _delayedTodoCount),
      ],
    );
  }

  Widget _buildColouredStripeArea() {
    int sum = _finishedTodoCount + _delayedTodoCount;
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildColouredStripe(
              _finishedTodoCount / sum, const Color(0xff51d2c2)),
          _buildColouredStripe(
              _delayedTodoCount / sum, const Color(0xffffb258)),
        ],
      ),
    );
  }

  Widget _buildTodoListArea() {
    return ListView.builder(
      itemCount: _todosOfThisMonth.length,
      itemBuilder: (context, index) {
        Todo todo = _todosOfThisMonth[index];
        return GestureDetector(
          onTap: () => _onTap(todo),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    color: todo.status.color,
                    height: 10,
                    width: 10,
                    margin: const EdgeInsets.all(10),
                  ),
                  Text(todo.title),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.access_time,
                      size: 15,
                      color: Color(0xffb9b9bc),
                    ),
                    Text(' ${todo.startTime.hour} - ${todo.endTime.hour}',
                        style: const TextStyle(color: Color(0xffb9b9bc))),
                  ],
                ),
              ),
              Container(
                height: 1,
                color: const Color(0xffececed),
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildColouredStripe(double percentage, Color color) {
    if (percentage < 0 || percentage.isNaN) {
      return Container();
    }
    return SizedBox(
      height: 10,
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: percentage,
        child: DecoratedBox(
          decoration: BoxDecoration(color: color),
        ),
      ),
    );
  }

  Widget _buildTodoStatusView(TodoStatus? status, int count) {
    status ??= TodoStatus.unspecified;
    return Expanded(
      flex: 1,
      child: Column(
        children: <Widget>[
          Text(status.description, style: const TextStyle(fontSize: 16)),
          Text(count.toString(), style: const TextStyle(fontSize: 33)),
          Container(
            color: status.color,
            height: 10,
            width: 10,
            margin: const EdgeInsets.all(10),
          )
        ],
      ),
    );
  }
}
