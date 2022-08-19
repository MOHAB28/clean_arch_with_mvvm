import 'package:shared_preferences/shared_preferences.dart';
import '../presentation/resources/language_manager.dart';

class AppPrefrences {
  final SharedPreferences _sharedPreferences;
  AppPrefrences(this._sharedPreferences);

  String keyPrefsLang = 'keyPrefsLang';
  String keyPrefsOnBoardingScreenViewed = 'keyPrefsOnBoardingScreenViewed';
  String keyPrefsUserLoggedIn = 'keyPrefsUserLoggedIn';
  Future<String> getLanguage() async {
    final language = _sharedPreferences.getString(keyPrefsLang);
    if(language != null && language.isNotEmpty) {
      return language;
    } else {
      return LanguageType.english.value;
    }
  }

  Future<void> setOnBoardingScreenViewed() async {
    _sharedPreferences.setBool(keyPrefsOnBoardingScreenViewed, true);
  }
  Future<bool> isOnBoardingScreenViewed() async {
    return _sharedPreferences.getBool(keyPrefsOnBoardingScreenViewed) ?? false;
  }


  Future<void> setUserLoggedIn() async {
    _sharedPreferences.setBool(keyPrefsUserLoggedIn, true);
  }
  Future<bool> isUserLoggedIn() async {
    return _sharedPreferences.getBool(keyPrefsUserLoggedIn) ?? false;
  }
}