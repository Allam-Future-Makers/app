import 'package:app/constants/translation.dart';
import 'package:app/constants/ui.dart';
import 'package:app/ui/screens/auth/login_screen.dart';
import 'package:app/ui/screens/auth/register_screen.dart';
import 'package:app/ui/screens/auth/splash_screen.dart';
import 'package:app/ui/screens/features/chat_screen.dart';
import 'package:app/ui/screens/features/enhancer_screen.dart';
import 'package:app/ui/screens/features/irab_screen.dart';
import 'package:app/ui/screens/features/lookup_screen.dart';
import 'package:app/ui/screens/features/msa_screen.dart';
import 'package:app/ui/screens/features/quran_screen.dart';
import 'package:app/ui/screens/features/tashkeel_screen.dart';
import 'package:app/ui/screens/home_screen.dart';
import 'package:app/ui/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translationsKeys: AppTranslations.keys,
      locale: const Locale('ar'),
      fallbackLocale: const Locale('en'),

      title: 'Allam Future Makers',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
          primary: UIConstants.primaryColor,
          secondary: UIConstants.secondaryColor,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.cairoTextTheme(),
      ),
      //routing
      routes: {
        "/": (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/homee': (context) => const HomeScreen(),
        '/irab': (context) => IrabScreen(),
        '/tashkeel': (context) => TashkeelScreen(),
        '/msa': (context) => MSAScreen(),
        '/lookup': (context) => LookupScreen(),
        '/quran': (context) => QuranScreen(),
        '/enhancer': (context) => EnhancerScreen(),
        "/chat": (context) => const ChatScreen(),
        "/settings": (context) => const SettingsScreen(),
      },
    );
  }
}
