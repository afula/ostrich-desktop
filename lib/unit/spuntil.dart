import 'package:shared_preferences/shared_preferences.dart';

class SPUtils {
  SPUtils._internal();

  static SharedPreferences? _spf;

  static Future<SharedPreferences?> init() async {
    if (_spf == null) {
      _spf = await SharedPreferences.getInstance();
    }
    return _spf;
  }



  ///语言
  static Future<bool>? saveLocale(String locale) {
    return _spf?.setString('key_locale', locale);
  }

  static String getLocale() {
    String? locale = _spf?.getString('key_locale');
    if (locale == null) {
      locale = 'zh';
    }
    return locale;
  }

}