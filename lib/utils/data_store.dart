import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String phonePreferenceKey = 'todos_user_info_phone_key';
const String passwordPreferenceKey = 'todos_user_info_password_key';
const String loginPreferenceKey = 'todos_user_info_login_key';

// 设置/获取注册登录的用户信息
// 注册: 将用户信息永久保存在registerPreferenceKey
// 登录: 检查并对比注册的用户信息，设置登录信息loginPreferenceKey
// 登出: 删除登录信息
class UserInfo {
  UserInfo._();
  static final UserInfo _instance = UserInfo._();
  SharedPreferences? _sharedPreferences;

  factory UserInfo.instance() => _instance;

  Future<void> _initSharedPreferences() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  // 设置注册的用户信息
  Future<void> registerUserInfo(String phone, String password) async {
    await _initSharedPreferences();
    String phoneValue = sha256.convert(utf8.encode(phone)).toString();
    String passwordValue = sha256.convert(utf8.encode(password)).toString();

    await _sharedPreferences?.setString(phonePreferenceKey, phoneValue);
    await _sharedPreferences?.setString(passwordPreferenceKey, passwordValue);
  }

  Future<void> removeUserInfo() async {
    await _initSharedPreferences();
    await _sharedPreferences?.remove(phonePreferenceKey);
    await _sharedPreferences?.remove(passwordPreferenceKey);
    await _sharedPreferences?.remove(loginPreferenceKey);
  }

  // 登录
  Future<bool> login(String phone, String password) async {
    await _initSharedPreferences();
    // 获取注册的用户信息
    String? registeredPhoneValue =
        _sharedPreferences?.getString(phonePreferenceKey);
    String? registeredPasswordValue =
        _sharedPreferences?.getString(passwordPreferenceKey);
    // 登录信息转换
    String phoneValue = sha256.convert(utf8.encode(phone)).toString();
    String passwordValue = sha256.convert(utf8.encode(password)).toString();
    // 判断
    if (phoneValue == registeredPhoneValue &&
        passwordValue == registeredPasswordValue) {
      _sharedPreferences?.setString(loginPreferenceKey, phoneValue);
      return true;
    }
    return false;
  }

  // 获取登录凭证loginPreferenceKey的值
  Future<String?> getLoginKey() async {
    await _initSharedPreferences();
    if (_sharedPreferences!.containsKey(loginPreferenceKey)) {
      return _sharedPreferences?.getString(loginPreferenceKey);
    }
    return '';
  }

  // 登出
  Future<void> logout() async {
    await _initSharedPreferences();
    if (_sharedPreferences!.getString(loginPreferenceKey) != null) {
      _sharedPreferences?.remove(loginPreferenceKey);
    }
  }
}
