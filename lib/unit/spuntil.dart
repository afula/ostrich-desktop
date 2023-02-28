import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class SPUtils {
  SPUtils._internal();

  static SharedPreferences? _spf;

  static Future<SharedPreferences?> init() async {
    _spf ??= await SharedPreferences.getInstance();
    // await _spf?.clear();
    return _spf;
  }

  ///语言
  static Future<bool>? saveLocale(String locale) {
    return _spf?.setString('key_locale', locale);
  }

  static String getLocale() {
    String? locale = _spf?.getString('key_locale');
    locale ??= Platform.localeName.split('_')[0];
    Logger().d("set locale to: $locale");
    return locale;
  }
}
