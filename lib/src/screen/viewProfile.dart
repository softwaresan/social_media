import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:social_media/src/controller/myProvider.dart';
import 'package:social_media/src/model/social_user_model.dart';
import 'package:social_media/src/screen/addNewPost.dart';
import 'package:social_media/src/screen/chatScreen.dart';
import 'package:social_media/src/screen/editProfileScreen.dart';

import '../controller/themeProvider.dart';
import 'myFollowers.dart';
import 'myFollowings.dart';

class ViewProfile extends StatefulWidget {
  ViewProfile({Key? key, this.friendUser, required this.isFollowed})
      : super(key: key);
  var friendUser;

  bool isFollowed;
  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  String? followState;
  int? _myPosts;
  int? _myFollowings;
  int? _myFollowers;
  var _myFollowingsUsers = [];
  var _myFollowersUsers = [];

  @override
  void initState() {
    super.initState();

    Provider.of<MyProvider>(context, listen: false).isMyAnalysisReady = false;
    Future.delayed(Duration.zero, () async {
      await Provider.of<MyProvider>(context, listen: false)
          .getMyAnalysis(widget.friendUser["uid"]);
      _myPosts = Provider.of<MyProvider>(context, listen: false).myPosts;
      _myFollowings =
          Provider.of<MyProvider>(context, listen: false).myFollowings;
      _myFollowers =
          Provider.of<MyProvider>(context, listen: false).myFollowers;
      _myFollowingsUsers =
          Provider.of<MyProvider>(context, listen: false).myFollowingsUsers;
      _myFollowersUsers =
          Provider.of<MyProvider>(context, listen: false).myFollowersUsers;
    });

    print("hello");

    followState = widget.isFollowed ? "UnFollow" : "Follow";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Provider.of<MyProvider>(context, listen: false)
                    .messageController
                    .text = "";
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ChatScreen(friendUser: widget.friendUser!);
                }));
              },
              icon: Icon(
                Icons.chat_outlined,
                color: Theme.of(context).primaryColor,
              ))
        ],
        centerTitle: true,
        title: Text(
          widget.friendUser!["name"],
          style: Theme.of(context).textTheme.subtitle1,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).primaryColor,
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Builder(builder: (context) {
        if (!Provider.of<MyProvider>(context).isMyAnalysisReady) {
          // _myPosts = Provider.of<MyProvider>(context, listen: false).myPosts;
          // _myFollowings =
          //     Provider.of<MyProvider>(context, listen: false).myFollowings;
          // _myFollowers =
          //     Provider.of<MyProvider>(context, listen: false).myFollowers;

          // Future.delayed(Duration.zero, () async {
          //   Provider.of<MyProvider>(context, listen: false)
          //       .getMyAnalysis(widget.friendUser["uid"]);
          // });

          return Center(child: CircularProgressIndicator());
        } else {
          return SingleChildScrollView(
            child: Column(children: [
              Stack(
                  alignment: AlignmentDirectional.center,
                  clipBehavior: Clip.none,
                  children: [
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: Image.network(
                        widget.friendUser!["coverImg"],
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                      top: 120,
                      child: CircleAvatar(
                          radius: 65,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                NetworkImage(widget.friendUser!["profileImg"]),
                          )),
                    )
                  ]),
              SizedBox(height: 50),
              Text(widget.friendUser!["name"],
                  style: Theme.of(context).textTheme.subtitle1),
              SizedBox(height: 5),
              Text(widget.friendUser!["bio"],
                  style: Theme.of(context).textTheme.caption),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: Provider.of<ThemeProvider>(context, listen: false)
                            .isDarkMode
                        ? Colors.grey[800]
                        : Colors.grey[200],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text("Posts",
                              style: Theme.of(context).textTheme.subtitle1),
                          Text(_myPosts.toString(),
                              style: Theme.of(context).textTheme.subtitle1),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyFollowers(
                                  myFollowersUsers: _myFollowersUsers,
                                ))),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      color: Provider.of<ThemeProvider>(context, listen: false)
                              .isDarkMode
                          ? Colors.grey[800]
                          : Colors.grey[200],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text("Followers",
                                style: Theme.of(context).textTheme.subtitle1),
                            Text(_myFollowers.toString(),
                                style: Theme.of(context).textTheme.subtitle1)
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyFollowings(
                                  myFollowingsUsers: _myFollowingsUsers)));
                    },
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      color: Provider.of<ThemeProvider>(context, listen: false)
                              .isDarkMode
                          ? Colors.grey[800]
                          : Colors.grey[200],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text("Followings",
                                style: Theme.of(context).textTheme.subtitle1),
                            Text(_myFollowings.toString(),
                                style: Theme.of(context).textTheme.subtitle1)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () async {
                      print(widget.isFollowed);
                      Provider.of<MyProvider>(context, listen: false)
                          .followUser(widget.friendUser!["uid"],
                              widget.friendUser!["name"], widget.isFollowed);

                      if (widget.isFollowed) {
                        followState = "Follow";
                        widget.isFollowed = !widget.isFollowed;
                      } else {
                        followState = "UnFollow";
                        widget.isFollowed = !widget.isFollowed;
                      }
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(),
                            color: widget.isFollowed
                                ? Provider.of<ThemeProvider>(context,
                                            listen: false)
                                        .isDarkMode
                                    ? Colors.grey[800]
                                    : Colors.transparent
                                : Colors.blue,
                          ),
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: Center(
                              child: Text(
                            "$followState",
                            style: Provider.of<ThemeProvider>(context,
                                        listen: false)
                                    .isDarkMode
                                ? TextStyle(color: Colors.white)
                                : TextStyle(
                                    color: widget.isFollowed
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                          ))),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Container(
                  color: Colors.grey[300],
                  height: 1,
                ),
              ),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(widget.friendUser!["uid"])
                      .collection("myPosts")
                      .orderBy("dateTime", descending: true)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return SizedBox(
                        child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 4,
                                    mainAxisSpacing: 5),
                            itemBuilder: (context, index) {
                              return Image.network(
                                snapshot.data!.docs[index].data()["postImage"],
                                fit: BoxFit.fill,
                              );
                            }),
                      );
                    }
                  })
            ]),
          );
        }
      }),
    );
  }
}
