import 'package:flutter/cupertino.dart';

class ThemeProvider with ChangeNotifier {
  bool isDarkMode = false;
  changeThemeMode() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}
