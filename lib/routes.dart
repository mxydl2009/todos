import 'package:flutter/material.dart';
import 'package:todos/pages/login.dart';
import 'package:todos/pages/register.dart';
import 'pages/index.dart';
import 'pages/about.dart';
import 'pages/calendar.dart';
import 'pages/reporter.dart';
import 'pages/todoEdit.dart';
import 'pages/todoList.dart';

const LOGIN_PAGE_URL = '/login';
const REGISTER_PAGE_URL = '/register';
const INDEX_PAGE_URL = '/';
const ABOUT_PAGE_URL = '/about';
const CALENDAR_PAGE_URL = '/calendar';
const REPORTER_PAGE_URL = '/reporter';
const TODO_EDIT_PAGE_URL = '/edit';
const TODO_LIST_PAGE_URL = '/list';

final Map<String, WidgetBuilder> routes = {
  INDEX_PAGE_URL: (context) => const IndexPage(),
  LOGIN_PAGE_URL: (context) => const LoginPage(),
  REGISTER_PAGE_URL: (context) => const RegisterPage(),
  ABOUT_PAGE_URL: (context) => const AboutPage(),
  CALENDAR_PAGE_URL: (context) => const CalendarPage(),
  REPORTER_PAGE_URL: (context) => const ReporterPage(),
  TODO_EDIT_PAGE_URL: (context) => const TodoEditPage(),
  TODO_LIST_PAGE_URL: (context) => const TodoListPage()
};
