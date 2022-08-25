import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
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
  bool isLoading = true;
  Future<void> getUserData() async {
    isLoading = true;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final uId = auth.currentUser!.uid;
    final user = FirebaseFirestore.instance.collection("users").doc(uId);

    await user.get().then((value) {
      socialUser = SocialUser.fromMap(value.data()!);
      isLoading = false;
      notifyListeners();
    });
  }

  updateUserProfile(context) async {
    isLoading = true;
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
    isLoading = false;
    notifyListeners();
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
    isPosts = true;
    isLoading = true;
    posts = [];
    followings = [];
    users = [];
    isLiked = [];
    likes = [];
    comments = [];

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
    Uuid uuid = const Uuid();

    var ref = await FirebaseStorage.instance
        .ref()
        .child("newPosts/${Uri.file(newPostPath!).pathSegments.last}")
        .putFile(File(newPostPath!));
    await ref.ref.getDownloadURL().then((value) {
      postModel = PostModel(
          postImage: value,
          description: description.text == "" ? "" : description.text,
          dateTime: DateTime.now().toString(),
          uId: socialUser!.uid!,
          postId: uuid.v1());
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(socialUser!.uid)
        .collection("myPosts")
        .doc(postModel!.postId)
        .set(postModel!.toMap())
        .then((value) {
      newPostPath = null;
    });

    Navigator.pop(context);

    notifyListeners();
  }

  String? userSearch = "";
  TextEditingController messageController = TextEditingController();

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
        .doc()
        .set(message.toMap())
        .then((value) {});
    await FirebaseFirestore.instance
        .collection("users")
        .doc(receiverId)
        .collection("chats")
        .doc(socialUser!.uid)
        .collection("messages")
        .doc()
        .set(message.toMap())
        .then((value) {});
    messageController.text = "";
    notifyListeners();
  }

  likePost(String postId, String friendId, bool like) async {
    if (like) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(friendId)
          .collection("myPosts")
          .doc(postId)
          .collection("likes")
          .doc(socialUser!.uid)
          .delete();
    } else {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(friendId)
          .collection("myPosts")
          .doc(postId)
          .collection("likes")
          .doc(socialUser!.uid)
          .set({"like": true});
    }
    notifyListeners();
  }

  TextEditingController commentController = TextEditingController();

  //myPosts  => doc(postId) => Comments => doc(socialUser.id)

  commentPost(String postId, String friendId) async {
    if (commentController.text.trim() != "") {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(friendId)
          .collection("myPosts")
          .doc(postId)
          .collection("comments")
          .doc(socialUser!.uid)
          .set({
        "comment": commentController.text.trim(),
        "dateTime": DateFormat.yMd().add_jm().format(DateTime.now())
      });
      commentController.text = "";
      notifyListeners();
    }
  }

  followUser(String friendId, String friendName, bool isFollowed) async {
    var friendRef = FirebaseFirestore.instance
        .collection("users")
        .doc(friendId)
        .collection("followers")
        .doc(socialUser!.uid);
    var myRef = FirebaseFirestore.instance
        .collection("users")
        .doc(socialUser!.uid)
        .collection("followings")
        .doc(friendId);

    if (isFollowed) {
      await myRef.delete();
      await friendRef.delete();
    } else {
      await myRef.set({"name": friendName, "uId": friendId});

      await friendRef.set({"name": socialUser!.name, "uId": socialUser!.uid});
    }
    notifyListeners();
  }

  List followings = [];
  List posts = [];
  List users = [];
  List likes = [];
  List isLiked = [];
  List comments = [];

  bool isPosts = true;
  Future<void> getPosts() async {
    print("wer");

    await FirebaseFirestore.instance
        .collection("users")
        .doc(socialUser!.uid)
        .collection("followings")
        .get()
        .then((event) async {
      followings = event.docs.map((e) => e).toList();
      users = [];
      posts = [];
      likes = [];
      isLiked = [];
      comments = [];

      for (var element in followings) {
        //element= each following user with property
        await FirebaseFirestore.instance
            .collection("users")
            .doc(element["uId"])
            .collection("myPosts")
            .orderBy("dateTime", descending: true)
            .get()
            .then((event) async {
          for (var element in event.docs) {
            //element = each post with property
            posts.add(element);
            await FirebaseFirestore.instance
                .collection("users")
                .doc(element["uId"])
                .get()
                .then((value) {
              users.add(value);
            });
          }

          for (var element in event.docs) {
            var likesRef = FirebaseFirestore.instance
                .collection("users")
                .doc(element["uId"])
                .collection("myPosts")
                .doc(element["postId"])
                .collection("likes");

            await likesRef.get().then((value) {
              likes.add(value.docs.length);
            });
            var isExist = await likesRef.doc(socialUser!.uid).get();
            isLiked.add(isExist.exists);
          }
          for (var element in event.docs) {
            var commentRef = FirebaseFirestore.instance
                .collection("users")
                .doc(element["uId"])
                .collection("myPosts")
                .doc(element["postId"])
                .collection("comments");

            await commentRef.get().then((value) {
              comments.add(value.docs.length);
            });
          }
        });
      }
    });

    isPosts = false;
    notifyListeners();
  }

  List allChats = [];
  getAllChatsWithFriends() async {
    var chatRef = await FirebaseFirestore.instance
        .collection("users")
        .doc(socialUser!.uid)
        .collection("chats");
  }
}

//fake comment +1
//action button chat
//videos 
//delete posts and comments
//notifications
//error handling
//design

