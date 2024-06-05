import 'package:flutter/material.dart';
import 'package:todos/routes.dart';
import 'package:todos/components/fractionally_sized_transition.dart';
import 'package:todos/components/image_hero.dart';
import 'package:todos/utils/data_store.dart';
import 'package:todos/const/route_argument.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

// 状态组件，其中<LoginPage>是继承自StatefulWidget的泛型，这里指定为上面的LoginPage
// 在此状态组件中声明成员以及更新成员的方法，并且包含构建组件的方法build
class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  // FocusNode phoneFocusNode;
  late bool canLogin;
  late bool useHero;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // phoneFocusNode = FocusNode();
    canLogin = false;
    useHero = true;
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 360));
    // Animation<double> parentAnimationController =
    //     CurvedAnimation(parent: _animationController, curve: Curves.bounceIn);
    // Tween<double> tween = Tween<double>(begin: 0.4, end: 0.6);
    // _animation = tween.animate(parentAnimationController);
    // _animation.addListener(() {
    //   setState(() {});
    // });
    _animationController
        .forward()
        .then((value) => _animationController.reverse());
  }

  void _checkInputValid(String _) {
    bool isInputValid = _phoneController.text.length == 11 &&
        _passwordController.text.length >= 6;
    if (isInputValid == true) {
      setState(() {
        canLogin = true;
      });
    } else {
      setState(() {
        canLogin = false;
      });
    }
  }

  void _login(BuildContext context) async {
    if (!canLogin) {
      return;
    }
    String phone = _phoneController.text;
    String password = _passwordController.text;
    bool success = await UserInfo.instance().login(phone, password);

    String? registerKey = await UserInfo.instance().getRegisterKey();

    debugPrint('login success $success, registerKey $registerKey');
    if (success) {
      setState(() {
        useHero = false;
      });
      String userKey = await UserInfo.instance().getLoginKey() as String;
      await Navigator.of(context).pushReplacementNamed(INDEX_PAGE_URL,
          arguments: TodoEntryArgument(userKey));
    } else {
      debugPrint('login fail, should clear textfield $success');
      // 提示登录信息有误
      _phoneController.clear();
      _passwordController.clear();
      _showDialog(context);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('登录有误'),
          content: const Text('登录发生错误，请检查手机号或者密码后重新登录'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框
              },
              child: const Text('关闭'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String markAssetName = 'assets/images/mark.png';
    return GestureDetector(
      onTap: () {
        // TextField组件都有FocusNode实例，当组件被点击时，就会将FocusNode实例赋值给FocusManager.instance.primaryFocus属性
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        // 将所有组件用滚动容器包裹，在键盘弹起时，自动滚动到当前获取焦点的输入框位置
        body: SingleChildScrollView(
          // 控制Column组件的高度最大为屏幕高
          child: ConstrainedBox(
            constraints:
                // MediaQuery.of(context)返回MediaQueryData类型的数据，该数据来自于MetarialApp组件子组件
                // 子组件通过BuildContext参数可以轻松从祖先组件上获取context相关的数据，也是一种跨组件获取数据的方式inheritWidget机制
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: Center(
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: Container(
                          color: Colors.transparent,
                          child: Center(
                            child: FractionallySizedTransition(
                              // child: Image.asset('assets/images/mark.png'),
                              controller: _animationController,
                              beginFactor: 0.4,
                              endFactor: 0.5,
                              child: useHero
                                  ? ImageHero.asset(markAssetName)
                                  : Image.asset(markAssetName),
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
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    TextField(
                                      decoration: const InputDecoration(
                                          hintText: '请输入手机号',
                                          labelText: '手机',
                                          prefixIcon: Icon(Icons.phone_iphone)),
                                      keyboardType: TextInputType.phone,
                                      textInputAction: TextInputAction.next,
                                      onChanged: _checkInputValid,
                                      controller: _phoneController,
                                    ),
                                    TextField(
                                      decoration: const InputDecoration(
                                          hintText: '请输入6位以上的密码',
                                          labelText: '密码',
                                          prefixIcon: Icon(Icons.lock)),
                                      obscureText: true,
                                      onChanged: _checkInputValid,
                                      controller: _passwordController,
                                    ),
                                  ],
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0, right: 0, top: 24, bottom: 12),
                                    child: Container(
                                      child: FilledButton(
                                        child: const Text('登录'),
                                        // color: const Color(0xFF9BB2E0),
                                        onPressed: canLogin == true
                                            ? () {
                                                _login(context);
                                              }
                                            : null,
                                      ),
                                    )),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0, right: 0, top: 12, bottom: 12),
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          const Text('没有账号'),
                                          TextButton(
                                              child: const Text(
                                                '立即注册',
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pushReplacementNamed(
                                                        REGISTER_PAGE_URL);
                                              })
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          )))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
