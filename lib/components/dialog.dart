import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  const ProgressDialog({required Key key, required this.text})
      : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return const Dialog(
      child: Padding(
        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(width: 20, height: 20),
            Text('请求中...'),
          ],
        ),
      ),
    );
  }
}

class SimpleAlertDialog extends StatelessWidget {
  const SimpleAlertDialog(
      {required Key key, required this.title, required this.content})
      : super(key: key);

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(
        content,
        maxLines: 3,
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('确定'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
