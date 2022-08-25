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

  @override
  void initState() {
    print("hello");
    followState = widget.isFollowed ? "unFollow" : "Follow";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                color: Colors.black,
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
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
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
                      backgroundColor: Colors.white,
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Posts", style: Theme.of(context).textTheme.subtitle1),
              Text("Followers", style: Theme.of(context).textTheme.subtitle1),
              Text("Followings", style: Theme.of(context).textTheme.subtitle1),
            ],
          ),
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () async {
                    Provider.of<MyProvider>(context, listen: false).followUser(
                        widget.friendUser!["uid"],
                        widget.friendUser!["name"],
                        widget.isFollowed);

                    if (widget.isFollowed) {
                      followState = "Follow";
                      widget.isFollowed = !widget.isFollowed;
                    } else {
                      followState = "unFollow";
                      widget.isFollowed = !widget.isFollowed;
                    }
                    setState(() {});
                  },
                  child: Text("$followState"))),
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
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return SizedBox(
                    child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
      ),
    );
  }
}
