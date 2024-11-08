import 'package:app/constants/preferences.dart';
import 'package:app/helpers/pref_helper.dart';

class AppPrefs {
  static Future<String?> get token => PreferencesHelper.getString(Prefs.token);

  static Future setToken(String value) =>
      PreferencesHelper.setString(Prefs.token, value);
}
