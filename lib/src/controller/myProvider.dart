import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:social_media/src/model/messageModel.dart';
import 'package:social_media/src/model/postModel.dart';
import 'package:social_media/src/model/publicPostModel.dart';
import 'package:social_media/src/model/social_user_model.dart';
import 'package:social_media/src/model/videoModel.dart';
import 'package:social_media/src/screen/profile.dart';
import 'package:social_media/src/screen/search.dart';
import 'package:social_media/src/screen/settings.dart';
import 'package:images_picker/images_picker.dart';
import 'package:social_media/src/screen/videoShowScreen.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

import '../screen/home.dart';

class MyProvider with ChangeNotifier {
  int currentIndex = 0;

  List<Widget> screens = [
    Home(),
    Search(),
    Videos(),
    Profile(),
    const Setting()
  ];
  void changeScreen(int index) {
    if (index == 1) {
      userSearch = "";
    }

    currentIndex = index;
    notifyListeners();
  }

  bool showBottomSheet = false;
  void showBottomSheetFunction() {
    showBottomSheet = !showBottomSheet;
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
    chats = [];
    allChats = [];
    recentlyChatsUser = [];
    lastMsgWithFriend = [];

    await FirebaseAuth.instance.signOut();
  }

  String? newPostPath;
  newPostFromGallery() async {
    List<Media>? res = await ImagesPicker.pick(
      pickType: PickType.video,
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
      {required receiverId,
      required dateTime,
      required textMsg,
      lastMsgUserIndex}) async {
    messageController.text = "";

    MessageModel message = MessageModel(
        senderId: socialUser!.uid!,
        receiverId: receiverId,
        textMsg: textMsg,
        dateTime: dateTime);

    var myRef = FirebaseFirestore.instance
        .collection("users")
        .doc(socialUser!.uid)
        .collection("chats")
        .doc(receiverId);

    await myRef.set({"uId": receiverId});

    await myRef.collection("messages").add(message.toMap()).then((value) {});
    var friendRef = FirebaseFirestore.instance
        .collection("users")
        .doc(receiverId)
        .collection("chats")
        .doc(socialUser!.uid);
    await friendRef.set({"uId": socialUser!.uid});

    await friendRef
        .collection("messages")
        .add(message.toMap())
        .then((value) {});
    if (lastMsgUserIndex != null) {
      chats[lastMsgUserIndex]["lastMsg"] = textMsg;
    }
    notifyListeners();
  }

  likePost(String postId, String friendId, bool like, String type) async {
    if (like) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(friendId)
          .collection(type)
          .doc(postId)
          .collection("likes")
          .doc(socialUser!.uid)
          .delete();
    } else {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(friendId)
          .collection(type)
          .doc(postId)
          .collection("likes")
          .doc(socialUser!.uid)
          .set({"like": true});
    }
    notifyListeners();
  }

  TextEditingController commentController = TextEditingController();

  //myPosts  => doc(postId) => Comments => doc(socialUser.id)

  commentPost(String postId, String friendId, String type) async {
    if (commentController.text.trim() != "" ||
        videoCommentController.text != "") {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(friendId)
          .collection(type)
          .doc(postId)
          .collection("comments")
          .doc(socialUser!.uid)
          .set({
        "comment": type == "myPosts"
            ? commentController.text.trim()
            : videoCommentController.text.trim(),
        "uid": socialUser!.uid,
        "dateTime": DateFormat.yMd().add_jm().format(DateTime.now())
      });
      commentController.text = "";
      videoCommentController.text = "";

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

  List chats = [];
  List allChats = [];
  List recentlyChatsUser = [];
  List lastMsgWithFriend = [];
  bool isChat = true;
  Future<void> getAllChatsWithFriends() async {
    var chatRef = FirebaseFirestore.instance
        .collection("users")
        .doc(socialUser!.uid)
        .collection("chats");

    await chatRef.get().then((value) async {
      allChats = [];
      recentlyChatsUser = [];
      lastMsgWithFriend = [];

      chats = [];
      for (var element in value.docs) {
        await chatRef
            .doc(element.id)
            .collection("messages")
            .orderBy("dateTime")
            .get()
            .then((value) {
          lastMsgWithFriend.add(value.docs.last);
        });
        allChats.add(element);
      }

      for (var element in allChats) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(element.id)
            .get()
            .then((value) {
          recentlyChatsUser.add(value);
        });
      }
    });
    for (int i = 0; i < recentlyChatsUser.length; i++) {
      chats.add({
        "user": recentlyChatsUser[i],
        "lastMsg": lastMsgWithFriend[i]["textMsg"],
        "lastDateTime": lastMsgWithFriend[i]["dateTime"]
      });
    }

    isChat = false;
    notifyListeners();
  }

  Future<void> deleteChat(String friendId) async {
    final instance = FirebaseFirestore.instance;
    final batch = instance.batch();
    var collection = instance
        .collection("users")
        .doc(socialUser!.uid)
        .collection("chats")
        .doc(friendId)
        .collection("messages");
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(socialUser!.uid)
        .collection("chats")
        .doc(friendId)
        .delete();
    isChats();
  }

  isChats() {
    isChat = true;
    notifyListeners();
  }

  XFile? videoFile;
  bool isVideoPicked = true;

  TextEditingController videoTextController = TextEditingController();
  pickVideoFromCamera() async {
    ImagePicker _picker = ImagePicker();
    videoFile = await _picker.pickVideo(
        source: ImageSource.camera, maxDuration: const Duration(seconds: 10));
    isVideoPicked = false;
    notifyListeners();
  }

  pickVideoFromGallery() async {
    ImagePicker _picker = ImagePicker();
    videoFile = await _picker.pickVideo(
        source: ImageSource.gallery, maxDuration: const Duration(seconds: 10));
    isVideoPicked = false;
    notifyListeners();
  }

  VideoModel? videoModel;
  shareVideo(context) async {
    var ref = await FirebaseStorage.instance
        .ref()
        .child("Videos/${Uri.file(videoFile!.path).pathSegments.last}")
        .putFile(File(videoFile!.path));
    await ref.ref.getDownloadURL().then((value) {
      videoModel = VideoModel(
        videoUrl: value,
        description: 'description',
        uid: socialUser!.uid!,
      );
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(socialUser!.uid)
        .collection("myVideos")
        .add(videoModel!.toMap());
    Navigator.pop(context);
    notifyListeners();
  }

  List videos = [];
  List videoUser = [];
  List descriptionVideo = [];
  bool isVideoReady = false;
  List isVideoLiked = [];
  List videoLikesNumber = [];
  List videoComments = [];
  List videoCommentsNumber = [];
  List eachUserCommentVideo = [];

  List<List<dynamic>> usersCommentVideo = [];
  TextEditingController videoCommentController = TextEditingController();
  Future<void> getVideos() async {
    await FirebaseFirestore.instance
        .collectionGroup("myVideos")
        .get()
        .then((value) async {
      for (var element in value.docs) {
        videos.add(element);

        descriptionVideo.add(element["description"]);
        await FirebaseFirestore.instance
            .collection("users")
            .doc(element["uid"])
            .get()
            .then((value) {
          videoUser.add(value);
        });

        var likeRef = await FirebaseFirestore.instance
            .collection("users")
            .doc(element["uid"])
            .collection("myVideos")
            .doc(element["videoId"])
            .collection("likes");
        await likeRef.get().then((value) {
          videoLikesNumber.add(value.docs.length);
        });

        var isExist = await likeRef.doc(socialUser!.uid).get();
        isVideoLiked.add(isExist.exists);

        var commentRef = await FirebaseFirestore.instance
            .collection("users")
            .doc(element["uid"])
            .collection("myVideos")
            .doc(element["videoId"])
            .collection("comments");
        await commentRef.get().then((value) async {
          for (var element in value.docs) {
            await FirebaseFirestore.instance
                .collection("users")
                .doc(element["uid"])
                .get()
                .then((value) {
              print("add to small");
              eachUserCommentVideo.add(value);
            });
          }
          print("add to large");
          usersCommentVideo.add(eachUserCommentVideo);
          print("deleted");
          eachUserCommentVideo = [];
        });

        await commentRef.get().then((value) {
          videoComments.add(value.docs);
          videoCommentsNumber.add(value.docs.length);
        });
      }
    });
    print(usersCommentVideo);

    isVideoReady = true;
    notifyListeners();
  }
}



//delete posts and comments
//notifications 
//error handling/search for chats has a bug
//design

