import 'package:app/constants/ui.dart';
import 'package:app/providers/state.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/services/prefs_service.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    AppPrefs.token.then((token) {
      if (token != null) {
        AuthService().me(token).then((user) {
          AppState.user.value = user;
          Navigator.pushReplacementNamed(context, '/home');
        }).catchError((e) {
          Navigator.pushReplacementNamed(context, '/login');
        });
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: UIConstants.backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text("AQSA",
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(height: 20),
              CircularProgressIndicator(),
              const SizedBox(height: 200),
              Text(
                "Allam Future Makers",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          ),
        ));
  }
}
