import 'package:flutter/material.dart';
import 'package:todos/model/todo.dart';

class DeleteTodoDialog extends Dialog {
  final Todo todo;

  const DeleteTodoDialog({super.key, required this.todo});

  _dismissDialog(BuildContext context, bool delete) {
    Navigator.of(context).pop(delete);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _dismissDialog(context, false);
      },
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          _createTitleWidget(context, todo.title),
                          _createDescWidget(todo.description),
                        ],
                      ),
                    ),
                    _createOperationWidget(context)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _createTitleWidget(BuildContext context, String title) {
    return Row(
      children: <Widget>[
        Container(
          height: 15.0,
          width: 15.0,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(7.5)),
              color: Color.fromARGB(255, 80, 210, 194)),
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              maxLines: 1,
              style: const TextStyle(
                  color: Color.fromARGB(255, 74, 74, 74),
                  fontSize: 18,
                  fontFamily: 'Avenir'),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Container(
              height: 1.0,
              color: const Color.fromARGB(255, 216, 216, 216),
            ),
          ),
        ),
      ],
    );
  }

  Widget _createTimeWidget(String time) {
    return Row(
      children: <Widget>[
        Image.asset(
          'assets/images/time.png',
          width: 60.0,
          height: 60.0,
        ),
        Expanded(
          child: Text(
            time,
            style: const TextStyle(color: Colors.black, fontSize: 14),
          ),
        )
      ],
    );
  }

  Widget _createDescWidget(String desc) {
    return Container(
      child: Text(
        desc,
        style: const TextStyle(fontSize: 13, color: Colors.black),
      ),
    );
  }

  Widget _createOperationWidget(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            onTap: () {
              _dismissDialog(context, false);
            },
            child: Container(
              alignment: Alignment.center,
              height: 50,
              color: const Color.fromARGB(255, 221, 221, 221),
              child: const Text(
                '取消',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              _dismissDialog(context, true);
            },
            child: Container(
              alignment: Alignment.center,
              height: 50,
              color: const Color.fromARGB(255, 255, 92, 92),
              child: const Text(
                '删除',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        )
      ],
    );
  }
}
