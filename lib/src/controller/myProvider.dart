import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:social_media/src/model/social_user_model.dart';
import 'package:social_media/src/screen/profile.dart';
import 'package:social_media/src/screen/search.dart';
import 'package:social_media/src/screen/settings.dart';
import 'package:images_picker/images_picker.dart';

import '../screen/home.dart';

class MyProvider with ChangeNotifier {
  int currentIndex = 0;
  String? path;
  List<Widget> screens = [Home(), Search(), Profile(), const Setting()];
  void changeScreen(int index) {
    currentIndex = index;
    notifyListeners();
  }

  SocialUser? socialUser;
  void getUserData() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final uId = auth.currentUser!.uid;

    FirebaseFirestore.instance.collection("users").doc(uId).get().then((value) {
      socialUser = SocialUser.fromMap(value.data()!);
      notifyListeners();
    });
  }

  changeProfilePic() async {
    List<Media>? res = await ImagesPicker.pick(
      pickType: PickType.all,
      language: Language.System,
      maxTime: 30,
      // maxSize: 500,
      cropOpt: CropOption(
        // aspectRatio: CropAspectRatio.wh16x9,
        cropType: CropType.circle,
      ),
    );
    if (res != null) {
      path = res[0].thumbPath;

      notifyListeners();
      // bool status = await ImagesPicker.saveImageToAlbum(File(res[0]?.path));
      // print(status);
    }
  }
}
