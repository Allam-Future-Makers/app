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

    //delay
    Future.delayed(const Duration(seconds: 2), () {
      AppPrefs.token.then((token) {
        if (token != null) {
          AuthService().me(token).then((user) {
            AppState.user.value = user;
            Navigator.pushReplacementNamed(context, '/homee');
          }).catchError((e) {
            Navigator.pushReplacementNamed(context, '/login');
            print(e);
          });
        } else {
          Navigator.pushReplacementNamed(context, '/login');
        }
      });
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
              SizedBox(height: 20),
              CircularProgressIndicator(),
              SizedBox(height: 200),
              Text(
                "Allam Future Makers",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          ),
        ));
  }
}
