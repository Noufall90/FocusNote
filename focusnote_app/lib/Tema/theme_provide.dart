import 'package:flutter/material.dart';
import 'package:focusnote_app/Tema/theme.dart';

class ThemeProvide with ChangeNotifier
{
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData)
  {
    _themeData = themeData;
    notifyListeners();
  }

  void textController ()
  {
    if(_themeData == lightMode)
    {
      themeData = darkMode;
    }
    else 
    {
      themeData = lightMode;
    }
  }
}