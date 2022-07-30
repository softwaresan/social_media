import 'package:flutter/cupertino.dart';
import 'package:social_media/src/screen/profile.dart';
import 'package:social_media/src/screen/search.dart';
import 'package:social_media/src/screen/settings.dart';

import '../screen/home.dart';

class MyProvider with ChangeNotifier {
  int currentIndex = 0;
  List<Widget> screens = [Home(), Search(), Profile(), Settings()];
  void changeScreen(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
