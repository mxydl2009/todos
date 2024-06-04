import 'package:flutter/material.dart';
import 'package:todos/routes.dart';
import 'package:todos/components/image_hero.dart';
import 'package:todos/utils/data_store.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Future<void> _logout() async {
    await UserInfo.instance().logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('关于')),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
                child: Container(
                    color: Colors.transparent,
                    child: Center(
                      child: FractionallySizedBox(
                        widthFactor: 0.3,
                        heightFactor: 0.3,
                        child: ImageHero.asset('assets/images/mark.png'),
                      ),
                    ))),
            Expanded(
                child: Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const Padding(
                              padding: EdgeInsets.only(
                                  left: 0, right: 0, top: 24, bottom: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Center(
                                    child: Text(
                                      'Funny Flutter Todo',
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ),
                                  Center(
                                    child: Text('版本1.0.0'),
                                  )
                                ],
                              )),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 0, right: 0, top: 12, bottom: 12),
                              child: FilledButton(
                                  onPressed: () {
                                    _logout();
                                    Navigator.of(context)
                                        .pushReplacementNamed(LOGIN_PAGE_URL);
                                  },
                                  child: const Text(
                                    '退出登录',
                                    style: TextStyle(color: Colors.white),
                                  )))
                        ],
                      ),
                    )))
          ],
        ),
      ),
    );
  }
}
