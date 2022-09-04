// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controller/myProvider.dart';

class Viewpost extends StatelessWidget {
  Viewpost(
      {required this.postId,
      required this.userId,
      required this.dateTime,
      required this.numberOfLikes,
      required this.profileImg,
      required this.name,
      required this.description,
      required this.postImg,
      required this.isLiked,
      required this.commentsNo});
  String postId;
  String userId;
  String profileImg;
  String dateTime;
  int numberOfLikes;
  String name;
  String description;
  String postImg;
  bool isLiked;
  int commentsNo;

  @override
  Widget build(BuildContext context) {
    print("$numberOfLikes elel");
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "COMMENTS",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(userId)
                    .collection("myPosts")
                    .doc(postId)
                    .collection("comments")
                    .orderBy("dateTime")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.data == null) {
                    return Text("no comments");
                  }
                  {
                    return Column(
                      children: [
                        Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 20,
                          child: Column(
                            children: [
                              ListTile(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 5),
                                title: Text(name),
                                subtitle: Text(dateTime),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(profileImg),
                                  radius: 24,
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.more_horiz),
                                  onPressed: () {},
                                ),
                              ),
                              Divider(
                                color: Colors.grey,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    description,
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Card(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: Image.network(
                                    postImg,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  children: [
                                    isLiked
                                        ? Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                          )
                                        : Icon(Icons.favorite_outline),
                                    Text(numberOfLikes.toString()),
                                    Spacer(),
                                    Row(
                                      children: [
                                        Icon(Icons.add_comment_outlined),
                                        Text(snapshot.data!.docs.length
                                            .toString()),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Divider(
                                  color: Colors.grey,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          Provider.of<MyProvider>(context,
                                                  listen: false)
                                              .socialUser!
                                              .profileImg),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        child: TextField(
                                          controller: Provider.of<MyProvider>(
                                                  context,
                                                  listen: false)
                                              .commentController,
                                          onSubmitted: (value) {
                                            Provider.of<MyProvider>(context,
                                                    listen: false)
                                                .commentPost(postId, userId);
                                          },
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                              label: Text("Write A Comment"),
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.never),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Provider.of<MyProvider>(context,
                                                listen: false)
                                            .getPosts();
                                        Provider.of<MyProvider>(context,
                                                listen: false)
                                            .likePost(postId, userId, isLiked,
                                                "myPosts");

                                        if (isLiked) {
                                          isLiked = !isLiked;
                                          numberOfLikes--;
                                          print("$numberOfLikes elte5");
                                        } else {
                                          isLiked = !isLiked;
                                          numberOfLikes++;
                                          print("$numberOfLikes elte5");
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          isLiked
                                              ? Icon(
                                                  Icons.favorite,
                                                  color: Colors.red,
                                                )
                                              : Icon(Icons
                                                  .favorite_border_outlined),
                                          Text("Like"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return FutureBuilder<
                                    DocumentSnapshot<Map<String, dynamic>>>(
                                future: FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(snapshot.data!.docs[index].id)
                                    .get(),
                                builder: (context, builder) {
                                  if (builder.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else {
                                    return Card(
                                      child: ListTile(
                                        style: ListTileStyle.drawer,
                                        leading: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              builder.data!["profileImg"]),
                                        ),
                                        title: Row(
                                          children: [
                                            Text(builder.data!["name"] + " :"),
                                            Spacer(),
                                            Text(
                                              snapshot.data!.docs[index]
                                                  .data()["dateTime"],
                                            ),
                                          ],
                                        ),
                                        subtitle: Container(
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10),
                                                  topRight:
                                                      Radius.circular(10)),
                                              color: Colors.grey[300]),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(snapshot
                                                .data!.docs[index]
                                                .data()["comment"]),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                });
                          },
                        ),
                      ],
                    );
                  }
                }),
          ],
        ),
      ),
    ));
  }
}
