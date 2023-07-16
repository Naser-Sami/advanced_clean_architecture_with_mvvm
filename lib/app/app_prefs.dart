import 'package:advanced_clean_architecture_with_mvvm/app/constants.dart';
import 'package:advanced_clean_architecture_with_mvvm/data/network/language_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  final SharedPreferences _sharedPreferences;
  AppPreferences(this._sharedPreferences);

  Future<String> getAppLanguage() async {
    String? language = _sharedPreferences.getString(Constants.prefsKeyLang);

    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      // .. return default language
      return LanguageType.ENGLISH.getValue();
    }
  }

  // .. on boarding
  // .. set
  Future<void> setOnboardingScreenViewed() async {
    _sharedPreferences.setBool(Constants.prefsKeyOnboardingScreenViewed, true);
  }

  // .. get
  Future<bool> isOnboardingScreenViewed() async {
    return _sharedPreferences
            .getBool(Constants.prefsKeyOnboardingScreenViewed) ??
        false;
  }

  // .. login screen
  // .. set
  Future<void> setUserLoggedIn() async {
    _sharedPreferences.setBool(Constants.prefsKeyIsUserLoggedIn, true);
  }

  // .. get
  Future<bool> isUserLoggedIn() async {
    return _sharedPreferences.getBool(Constants.prefsKeyIsUserLoggedIn) ??
        false;
  }
}
