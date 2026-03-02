import 'package:mis_mobile/core/utils/app/language_manger.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String PREFS_KEY_IS_USER_LOGGED_IN = "PREFS_KEY_IS_USER_LOGGED_IN";
const String PREFS_KEY_ACCESS_TOKEN = "PREFS_KEY_ACCESS_TOKEN";
const String PREFS_KEY_REFRESH_TOKEN = "PREFS_KEY_REFRESH_TOKEN";
const String PREFS_KEY_USER_ID = "PREFS_KEY_USER_ID";
const String PREFS_KEY_LANG = "PREFS_KEY_LANG";

class AppPreferences {
  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  Future<void> setIsUserLoggedIn() async {
    _sharedPreferences.setBool(PREFS_KEY_IS_USER_LOGGED_IN, true);
  }

  Future<bool> isUserLoggedIn() async {
    return _sharedPreferences.getBool(PREFS_KEY_IS_USER_LOGGED_IN) ?? false;
  }

  Future<void> setAccessToken(String accessToken) async {
    _sharedPreferences.setString(PREFS_KEY_ACCESS_TOKEN, accessToken);
  }

  Future<String> getAccessToken() async {
    return _sharedPreferences.getString(PREFS_KEY_ACCESS_TOKEN) ?? '';
  }

  Future<void> setRefreshToken(String refreshToken) async {
    _sharedPreferences.setString(PREFS_KEY_REFRESH_TOKEN, refreshToken);
  }

  Future<String> getRefreshToken() async {
    return _sharedPreferences.getString(PREFS_KEY_REFRESH_TOKEN) ?? '';
  }

  Future<void> setUserId(String userId) async {
    _sharedPreferences.setString(PREFS_KEY_USER_ID, userId);
  }

  Future<String> getUserId() async {
    return _sharedPreferences.getString(PREFS_KEY_USER_ID) ?? '';
  }

  Future<void> logout() async {
    _sharedPreferences.remove(PREFS_KEY_IS_USER_LOGGED_IN);
  }

  Future<String> getAppLanguage() async {
    String? language = _sharedPreferences.getString(PREFS_KEY_LANG);

    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      return LanguageType.ENGLISH.getValue();
    }
  }
}
