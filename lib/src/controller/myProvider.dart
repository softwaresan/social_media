import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:social_media/src/model/messageModel.dart';
import 'package:social_media/src/model/postModel.dart';
import 'package:social_media/src/model/publicPostModel.dart';
import 'package:social_media/src/model/social_user_model.dart';
import 'package:social_media/src/screen/profile.dart';
import 'package:social_media/src/screen/search.dart';
import 'package:social_media/src/screen/settings.dart';
import 'package:images_picker/images_picker.dart';
import 'package:uuid/uuid.dart';

import '../screen/home.dart';

class MyProvider with ChangeNotifier {
  int currentIndex = 0;

  List<Widget> screens = [Home(), Search(), Profile(), const Setting()];
  void changeScreen(int index) {
    if (index == 1) {
      userSearch = "";
    }
    currentIndex = index;
    notifyListeners();
  }

  String? profilePicPath;
  String? coverPicPath;
  String? postImage;
  SocialUser? socialUser;
  String? tempCoverImg;
  String? tempProfileImg;
  void getUserData() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final uId = auth.currentUser!.uid;
    final user = FirebaseFirestore.instance.collection("users").doc(uId);

    await user.get().then((value) {
      socialUser = SocialUser.fromMap(value.data()!);
    });
    notifyListeners();
  }

  updateUserProfile(context) async {
    if (coverPicPath != null) {
      await uploadCoverPic().then((value) => tempCoverImg = value);
    }
    if (profilePicPath != null) {
      await uploadProfilePic().then((value) => tempProfileImg = value);
    }
    updateName();
    updateBio();
    updatePhone();
    socialUser!.coverImg =
        tempCoverImg == null ? socialUser!.coverImg : tempCoverImg!;
    socialUser!.profileImg =
        tempProfileImg == null ? socialUser!.profileImg : tempProfileImg!;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(socialUser!.uid)
        .update(socialUser!.toMap());
    Navigator.pop(context);

    coverPicPath = null;
    profilePicPath = null;
    nameController.text = "";
    phoneController.text = "";
    bioController.text = "";
  }

  Future<String> uploadCoverPic() async {
    var ref = await FirebaseStorage.instance
        .ref()
        .child("CoverPic/${Uri.file(coverPicPath!).pathSegments.last}")
        .putFile(File(coverPicPath!));
    return await ref.ref.getDownloadURL();
  }

  Future<String> uploadProfilePic() async {
    var ref = await FirebaseStorage.instance
        .ref()
        .child("profilePic/${Uri.file(profilePicPath!).pathSegments.last}")
        .putFile(File(profilePicPath!));
    return await ref.ref.getDownloadURL();
  }

  changeCoverPic() async {
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
      coverPicPath = res[0].thumbPath;

      notifyListeners();
      // bool status = await ImagesPicker.saveImageToAlbum(File(res[0]?.path));
      // print(status);
    }
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
      profilePicPath = res[0].thumbPath;

      notifyListeners();
      // bool status = await ImagesPicker.saveImageToAlbum(File(res[0]?.path));
      // print(status);
    }
  }

  TextEditingController nameController = TextEditingController();
  updateName() {
    socialUser!.name = nameController.text;
  }

  TextEditingController phoneController = TextEditingController();

  updatePhone() {
    socialUser!.phone = phoneController.text;
  }

  TextEditingController bioController = TextEditingController();

  updateBio() {
    socialUser!.bio = bioController.text;
  }

  userSignOut() async {
    await FirebaseAuth.instance.signOut();
  }

  String? newPostPath;
  newPostFromGallery() async {
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
      newPostPath = res[0].thumbPath;

      notifyListeners();
      // bool status = await ImagesPicker.saveImageToAlbum(File(res[0]?.path));
      // print(status);
    }
  }

  newPostFromCamera() async {
    List<Media>? res = await ImagesPicker.openCamera(
      pickType: PickType.image,
      language: Language.System,
      maxTime: 30,
      // maxSize: 500,
      cropOpt: CropOption(
        // aspectRatio: CropAspectRatio.wh16x9,
        cropType: CropType.circle,
      ),
    );
    if (res != null) {
      newPostPath = res[0].thumbPath;

      notifyListeners();
      // bool status = await ImagesPicker.saveImageToAlbum(File(res[0]?.path));
      // print(status);
    }
  }

  PostModel? postModel;
  // PublicPosts? publicPosts;
  TextEditingController description = TextEditingController();
  uploadNewPost(context) async {
    var ref = await FirebaseStorage.instance
        .ref()
        .child("newPosts/${Uri.file(newPostPath!).pathSegments.last}")
        .putFile(File(newPostPath!));
    await ref.ref.getDownloadURL().then((value) {
      postModel = PostModel(
          postImage: value,
          description: description.text == "" ? "" : description.text,
          dateTime: DateTime.now().toString());
    });
    Uuid uuid = const Uuid();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(socialUser!.uid)
        .collection("myPosts")
        .doc(uuid.v1())
        .set(postModel!.toMap())
        .then((value) {
      newPostPath = null;
    });

    Navigator.pop(context);

    notifyListeners();
  }

  String? userSearch = "";
  TextEditingController messageController = TextEditingController();
  final ScrollController listViewController = ScrollController();

  sendMessages(
      {required receiverId, required dateTime, required textMsg}) async {
    MessageModel message = MessageModel(
        senderId: socialUser!.uid!,
        receiverId: receiverId,
        textMsg: textMsg,
        dateTime: dateTime);

    await FirebaseFirestore.instance
        .collection("users")
        .doc(socialUser!.uid)
        .collection("chats")
        .doc(receiverId)
        .collection("messages")
        .add(message.toMap())
        .then((value) {
      notifyListeners();
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(receiverId)
        .collection("chats")
        .doc(socialUser!.uid)
        .collection("messages")
        .add(message.toMap())
        .then((value) {
      notifyListeners();
    });
    messageController.text = "";
    startFromBottom();
    notifyListeners();
  }

  startFromBottom() async {
    await listViewController.animateTo(
      listViewController.position.maxScrollExtent,
      duration: Duration(milliseconds: 1),
      curve: Curves.ease,
    );
  }

  likePost(String postId, String friendId) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(friendId)
        .collection("myPosts")
        .doc(postId)
        .collection("likes")
        .doc(socialUser!.uid)
        .set({"like": true});
    notifyListeners();
  }
}
