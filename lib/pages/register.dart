import 'package:flutter/material.dart';
import 'package:todos/routes.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:todos/utils/data_store.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

// 状态组件，其中<RegisterPage>是继承自StatefulWidget的泛型，这里指定为上面的RegisterPage
// 在此状态组件中声明成员以及更新成员的方法，并且包含构建组件的方法build
class _RegisterPageState extends State<RegisterPage> {
  // FocusNode phoneFocusNode;
  late bool canRegister;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final picker = ImagePicker();
  File? image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // phoneFocusNode = FocusNode();
    canRegister = false;
  }

  void _checkInputValid(String _) {
    bool passwordIsSame =
        _passwordController.text == _confirmPasswordController.text;
    bool isInputValid = _phoneController.text.length == 11 &&
        _passwordController.text.length >= 6 &&
        passwordIsSame;
    if (isInputValid == true) {
      setState(() {
        canRegister = true;
      });
    } else {
      setState(() {
        canRegister = false;
      });
    }
  }

  void _getImage() async {
    debugPrint('getImage start');
    // 从本地相册获取图片
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    debugPrint('picker getImage end, before setState');
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      }
    });
  }
  // @override
  // void dispose() {
  //   super.dispose();
  //   phoneFocusNode.dispose();
  // }

  void _register() async {
    if (!canRegister) return;
    // 注册
    await UserInfo.instance()
        .registerUserInfo(_phoneController.text, _passwordController.text);
    // 登录
    await UserInfo.instance()
        .login(_phoneController.text, _passwordController.text);
    Navigator.of(context).pushReplacementNamed(INDEX_PAGE_URL);
  }

  @override
  Widget build(BuildContext context) {
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
                          child: GestureDetector(
                            onTap: _getImage,
                            child: FractionallySizedBox(
                              // 按照一定比例来对子组件在可用空间进行缩放
                              widthFactor: 0.4,
                              heightFactor: 0.4,
                              child: Stack(
                                fit: StackFit.expand,
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 48,
                                    backgroundImage: image == null
                                        ? const AssetImage(
                                            'assets/images/default_avatar.png')
                                        : FileImage(image!),
                                  ),
                                  Positioned(
                                      right: 10,
                                      top: 10,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(17)),
                                            color: Color.fromARGB(
                                                255, 80, 210, 194)),
                                        child: const Icon(Icons.add,
                                            size: 34, color: Colors.white),
                                      ))
                                ],
                              ),
                            ),
                          ))),
                  Expanded(
                      child: Container(
                          color: const Color(0xFFFFFFFF),
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
                                    TextField(
                                      decoration: const InputDecoration(
                                          hintText: '请再次输入密码',
                                          labelText: '确认密码',
                                          prefixIcon: Icon(Icons.lock)),
                                      obscureText: true,
                                      onChanged: _checkInputValid,
                                      controller: _confirmPasswordController,
                                    ),
                                  ],
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0, right: 0, top: 24, bottom: 12),
                                    child: Container(
                                      child: ElevatedButton(
                                        child: const Text('注册并登录'),
                                        // color: const Color(0xFF9BB2E0),
                                        onPressed: canRegister == true
                                            ? _register
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
                                          const Text('已有账号'),
                                          TextButton(
                                              child: const Text(
                                                '立即登录',
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pushReplacementNamed(
                                                        LOGIN_PAGE_URL);
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
