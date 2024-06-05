import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
// import 'package:todos/extension/date_time.dart';

const String ID = 'id';
const String TITLE = 'title';
const String DESCRIPTION = 'description';
const String DATE = 'date';
const String START_TIME = 'start_time';
const String END_TIME = 'end_time';
const String PRIORITY = 'priority';
const String IS_FINISHED = 'is_finished';
const String IS_STAR = 'is_star';

timeOfDayToString(TimeOfDay timeOfDay) =>
    '${timeOfDay.hour}:${timeOfDay.minute}';
timeOfDayFromString(String string) {
  return TimeOfDay(
    hour: int.parse(string.split(':').first),
    minute: int.parse(string.split(':').last),
  );
}

class Todo {
  final String id;
  String title;
  String description;
  DateTime date;
  TimeOfDay startTime;
  TimeOfDay endTime;
  bool isFinished;
  bool isStar;
  Priority priority;

  Todo({
    String? id,
    this.title = '',
    this.description = '',
    required this.date,
    this.startTime = const TimeOfDay(hour: 0, minute: 0),
    this.endTime = const TimeOfDay(hour: 0, minute: 0),
    this.isFinished = false,
    this.isStar = false,
    this.priority = Priority.Unspecific,
  }) : id = id ?? generateNewId() {
    // date ??= DateTime.now().dayTime;
    // if (date == null) {
    //   date = DateTime.now().dayTime;
    // }
  }

  @override
  toString() {
    return 'todo is: $title, $description, $date, $startTime, $endTime, $isFinished, $isStar, $priority';
  }

  static const Uuid _uuid = Uuid();

  static String generateNewId() => _uuid.v1();

  TodoStatus get status {
    if (isFinished) {
      return TodoStatus.finished;
    }
    if (date.isBefore(DateTime.now())) {
      return TodoStatus.delay;
    }
    return TodoStatus.unspecified;
  }

  String get timeString {
    String dateString = date.compareTo(DateTime.now()) == 0
        ? 'today'
        : '${date.year}/${date.month}/${date.day}';
    // if (startTime == null || endTime == null) {
    //   return dateString;
    // }
    return '$dateString ${startTime.hour}:${startTime.minute} - ${endTime.hour}:${endTime.minute}';
  }

  Map<String, dynamic> toMap() {
    return {
      ID: id,
      TITLE: title,
      DESCRIPTION: description,
      DATE: date.millisecondsSinceEpoch.toString(),
      START_TIME: timeOfDayToString(startTime),
      END_TIME: timeOfDayToString(endTime),
      PRIORITY: priority.value,
      IS_FINISHED: isFinished ? 1 : 0,
      IS_STAR: isStar ? 1 : 0,
    };
  }

  static Todo fromMap(Map<String, dynamic> map) {
    return Todo(
        id: map[ID],
        title: map[TITLE],
        description: map[DESCRIPTION],
        date: DateTime.fromMillisecondsSinceEpoch(int.parse(map[DATE])),
        startTime: timeOfDayFromString(map[START_TIME]),
        endTime: timeOfDayFromString(map[END_TIME]),
        priority: Priority.values.firstWhere((p) => p.value == map[PRIORITY]),
        isFinished: map[IS_FINISHED] == 1 ? true : false,
        isStar: map[IS_STAR] == 1 ? true : false);
  }
}

class Priority {
  final int value;
  final String description;
  final Color color;
  const Priority._(this.value, this.description, this.color);

  @override
  bool operator ==(other) =>
      (other is Priority && other.value == value) || other == value;

  @override
  int get hashCode => value;

  bool isHigher(other) => other != null && other.value > value;

  factory Priority(int priority) =>
      values.firstWhere((e) => e.value == priority, orElse: () => Low);

  static const Priority High = Priority._(0, '高优先级', Color(0xFFE53B3B));
  static const Priority Medium = Priority._(1, '中优先级', Color(0xFFFF9400));
  static const Priority Low = Priority._(2, '低优先级', Color(0xFF14D4F4));
  static const Priority Unspecific = Priority._(3, '无优先级', Color(0xFF50D2C2));

  static const List<Priority> values = [High, Medium, Low, Unspecific];
}

class TodoStatus {
  /// 完成状态对应的数值，如 0
  final int value;

  /// 完成状态对应的文字描述，如“已完成”
  final String description;

  /// 完成状态对应的颜色，如红色
  final Color color;

  const TodoStatus._(this.value, this.description, this.color);

  /// 下面定义了允许用户使用的4个枚举值
  static const TodoStatus unspecified =
      TodoStatus._(0, '未安排', Color(0xff8c88ff));
  static const TodoStatus finished = TodoStatus._(1, '已完成', Color(0xff51d2c2));
  static const TodoStatus delay = TodoStatus._(2, '已延期', Color(0xffffb258));

  static const List<TodoStatus> values = [
    unspecified,
    finished,
    delay,
  ];
}
