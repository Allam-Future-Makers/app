import 'package:app/constants/preferences.dart';
import 'package:app/helpers/pref_helper.dart';

class AppPrefs {
  static Future<String> get userId => PreferencesHelper.getString(Prefs.userId);

  static Future setUserId(String value) =>
      PreferencesHelper.setString(Prefs.userId, value);
}
