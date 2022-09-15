import 'package:flutter/cupertino.dart';

class ThemeProvider with ChangeNotifier {
  bool isDarkMode = false;
  changeThemeMode() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }

  bool isSecure = false;
  secureText() {
    isSecure = !isSecure;
    notifyListeners();
  }
}
