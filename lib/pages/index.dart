import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos/config/colors.dart';
import 'package:todos/const/route_argument.dart';
import 'package:todos/model/todoList.dart';
import 'package:todos/pages/about.dart';
import 'package:todos/pages/calendar.dart';
import 'package:todos/pages/reporter.dart';
import 'package:todos/pages/todoList.dart';
import 'package:todos/routes.dart';
import 'package:todos/model/todo.dart';
import 'package:todos/utils/data_store.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int currentIndex = 0;
  List<Widget> pages = [];
  TodoList? todoList;
  String userKey = '';
  GlobalKey<TodoListPageState> todoListPageState =
      GlobalKey<TodoListPageState>();

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    pages = <Widget>[
      TodoListPage(key: todoListPageState),
      const CalendarPage(),
      Container(),
      const ReporterPage(),
      const AboutPage()
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    TodoEntryArgument arguments =
        ModalRoute.of(context)?.settings.arguments as TodoEntryArgument;
    String userKey = arguments.userKey;
    todoList = TodoList(userKey);
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(String imagePath,
      {double? size, bool singleImage = false}) {
    if (singleImage) {
      return BottomNavigationBarItem(
        icon: Image(width: size, height: size, image: AssetImage(imagePath)),
      );
    }
    ImageIcon activeIcon =
        ImageIcon(AssetImage(imagePath), size: size, color: activeTabIconColor);
    ImageIcon inactiveIcon = ImageIcon(AssetImage(imagePath),
        size: size, color: inactiveTabIconColor);
    return BottomNavigationBarItem(activeIcon: activeIcon, icon: inactiveIcon);
  }

  void _onTabChange(int index) async {
    if (index == 2) {
      // 创建待办
      Todo? todo = await Navigator.of(context).pushNamed(TODO_EDIT_PAGE_URL,
          arguments: EditTodoPageArgument(openType: OpenType.Add));

      if (todo != null) {
        index = 0;
        todoListPageState.currentState?.addTodo(todo);
        return;
      }
    }
    setState(() {
      currentIndex = index;
    });
  }

  // 检查是否登录
  Future<void> _checkLogin() async {
    String? userInfoKey = await UserInfo.instance().getLoginKey();
    if (userInfoKey == null) {
      Navigator.of(context).pushReplacementNamed(LOGIN_PAGE_URL);
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkLogin();
    return ChangeNotifierProvider<TodoList>.value(
        value: todoList!,
        child: Provider(
          create: (BuildContext context) => userKey,
          // create: (BuildContext context) => TodoList(generateTodos(3)),
          child: Scaffold(
            body: IndexedStack(index: currentIndex, children: pages),
            bottomNavigationBar: BottomNavigationBar(
                onTap: _onTabChange,
                currentIndex: currentIndex,
                type: BottomNavigationBarType.fixed,
                items: <BottomNavigationBarItem>[
                  _buildBottomNavigationBarItem('assets/images/lists.png'),
                  _buildBottomNavigationBarItem('assets/images/calendar.png'),
                  _buildBottomNavigationBarItem('assets/images/add.png',
                      size: 50, singleImage: true),
                  _buildBottomNavigationBarItem('assets/images/report.png'),
                  _buildBottomNavigationBarItem('assets/images/about.png')
                ]),
          ),
        ));
  }
}
