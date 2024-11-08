import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UIConstants {
  static const double titleFontSize = 18;
  static const Color backgroundColor = Color(0xff1C1760);
  static const newLine = SingleActivator(LogicalKeyboardKey.enter, shift: true);
  static const send = SingleActivator(LogicalKeyboardKey.enter, shift: false);
}
