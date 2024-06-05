import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todos/const/route_argument.dart';
import 'package:todos/extension/date_time.dart';
// import 'package:todos/extension/date_time.dart';
import 'package:todos/model/todo.dart';
import 'package:todos/model/todoList.dart';
import 'package:provider/provider.dart';
import 'package:todos/routes.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  // CalendarController _calendarController;
  late final ValueNotifier<DateTime> _focusedDay;
  late final ValueNotifier<DateTime?> _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  late TodoList _todoList;
  // late DateTime _initialDay;
  final Map<DateTime, List<Todo>> _date2TodoMap = {};
  final List<Todo> _todosToShow = [];

  @override
  void initState() {
    super.initState();
    _todoList = Provider.of<TodoList>(context, listen: false);
    // debugPrint('日历, ${_todoList.length}');
    // _calendarController = CalendarController();
    // _initialDay = DateTime.now().dayTime;
    _focusedDay = ValueNotifier(DateTime.now());
    _selectedDay = ValueNotifier(DateTime.now());

    _initDate2TodoMap();
    _todoList.addListener(_updateData);
    _selectedDay.addListener(() {
      // 更新为当前选中日期对应的事件(Todo列表);
      _todosToShow.clear();
      _todosToShow.addAll(_date2TodoMap[_selectedDay.value!.dayTime] ?? []);
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    _todoList = Provider.of(context, listen: false);
    _todoList.removeListener(_updateData);
    _todoList.addListener(_updateData);
  }

  @override
  void dispose() {
    _todoList.removeListener(_updateData);
    _focusedDay.dispose();
    _selectedDay.dispose();
    // _calendarController.dispose();
    super.dispose();
  }

  void _updateData() {
    setState(() {
      _todosToShow.clear();
      _date2TodoMap.clear();
      _initDate2TodoMap();
    });
  }

  void _initDate2TodoMap() {
    for (var todo in _todoList.list) {
      // 如果todo.date不存在，则使用() => []生成新的值为空数组
      _date2TodoMap.putIfAbsent(todo.date, () => []);
      _date2TodoMap[todo.date]?.add(todo);
      debugPrint('todo date: ${todo.date}');
      debugPrint('focusedDay: ${_focusedDay.value.dayTime}');
    }
    _todosToShow.addAll(_date2TodoMap[_focusedDay.value.dayTime] ?? []);
    debugPrint('_todosToShow ${_todosToShow.length}');
  }

  void _onTap(Todo todo) async {
    await Navigator.of(context).pushNamed(TODO_EDIT_PAGE_URL,
        arguments:
            EditTodoPageArgument(openType: OpenType.Preview, todo: todo));
    _todoList.update(todo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('日历'),
      ),
      body: Column(
        children: <Widget>[
          TableCalendar(
            focusedDay: _focusedDay.value,
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            calendarFormat: _calendarFormat,
            // calendarController: _calendarController,
            locale: 'zh_CN',
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay.value, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              debugPrint(
                  'selectedDay is $selectedDay, focusedDay is $focusedDay');
              setState(() {
                _selectedDay.value = selectedDay;
                _focusedDay.value =
                    focusedDay; // update `_focusedDay` here as well
              });
            },
            eventLoader: (day) {
              if (_date2TodoMap.containsKey(day)) {
                return _date2TodoMap[day]!;
              } else {
                return [];
              }
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay.value = focusedDay;
            },
            // events: _date2TodoMap,
            headerStyle: const HeaderStyle(),
            calendarStyle: const CalendarStyle(
                // todayColor: Colors.transparent,
                // todayStyle: TextStyle(color: Colors.black),
                ),
            // initialSelectedDay: _initialDay,
            // onDaySelected: (DateTime day, List events) {
            //   setState(() {
            //     _todosToShow = events.cast<Todo>();
            //   });
            // },
          ),
          Expanded(
            child: _buildTaskListArea(),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskListArea() {
    return ListView.builder(
      itemCount: _todosToShow.length,
      itemBuilder: (context, index) {
        Todo todo = _todosToShow[index];
        return GestureDetector(
          onTap: () => _onTap(todo),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    // color: todo.status.color,
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
                    Text(
                      ' ${todo.startTime.hour} - ${todo.endTime.hour}',
                      style: const TextStyle(color: Color(0xffb9b9bc)),
                    ),
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
}
