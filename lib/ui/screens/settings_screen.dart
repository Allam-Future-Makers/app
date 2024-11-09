import 'package:app/constants/ui.dart';
import 'package:app/services/prefs_service.dart';
import 'package:app/ui/widgets/glass.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //bottom bar with middle fab for chat
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      backgroundColor: UIConstants.backgroundColor,
      body: Glass(
        child: Column(
          children: [
            Row(
              children: [
                //Language Dropdown: Arabic/English
                const Text('Language: '),
                DropdownButton<String>(
                  value: Get.locale!.languageCode,
                  onChanged: (String? value) {
                    if (value != null) {
                      Get.updateLocale(Locale(value));
                    }
                  },
                  items: {"ar": "Arabic", "en": "English"}
                      .entries
                      .map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value.key,
                      child: Text(value.value),
                    );
                  }).toList(),
                ),
              ],
            ),
            //Logout button
            ElevatedButton(
              onPressed: () {
                AppPrefs.setToken(null);
                Get.toNamed('/login');
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}