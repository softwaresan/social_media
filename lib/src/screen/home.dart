import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:social_media/src/controller/myProvider.dart';
import 'package:social_media/src/model/social_user_model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: RefreshIndicator(
        onRefresh: () {
          setState(() {});
          return Future.delayed(Duration(milliseconds: 500));
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 20,
                child: Image.network(
                  "https://img.freepik.com/free-vector/young-people-standing-talking-each-other-speech-bubble-smartphone-girl-flat-vector-illustration-communication-discussion_74855-8741.jpg",
                  fit: BoxFit.fill,
                ),
              ),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collectionGroup("myPosts")
                      .snapshots(),
                  builder: (context, snapshot4) {
                    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.data == null) {
                            return Text("There is no posts for now");
                          } else if (snapshot.hasError) {
                            return Text("erro");
                          } else {
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot4.data!.docs.length,
                                itemBuilder: (context, index) {
                                  if (index < snapshot.data!.docs.length) {
                                    return StreamBuilder<
                                            QuerySnapshot<
                                                Map<String, dynamic>>>(
                                        stream: FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(snapshot.data!.docs[index].id)
                                            .collection("myPosts")
                                            .orderBy("dateTime",
                                                descending: true)
                                            .snapshots(),
                                        builder: (context, snapshot3) {
                                          if (snapshot3.connectionState ==
                                              ConnectionState.waiting) {
                                            return CircularProgressIndicator();
                                          } else if (snapshot3
                                                  .data!.docs.length !=
                                              0) {
                                            int generate = 0;

                                            return StreamBuilder<
                                                    QuerySnapshot<
                                                        Map<String, dynamic>>>(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection("users")
                                                    .doc(snapshot
                                                        .data!.docs[index].id)
                                                    .collection("myPosts")
                                                    .doc(snapshot3.data!
                                                        .docs[generate].id)
                                                    .collection("likes")
                                                    .snapshots(),
                                                builder: (context, snapshot2) {
                                                  if (snapshot2
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return CircularProgressIndicator();
                                                  }

                                                  return Card(
                                                    clipBehavior: Clip
                                                        .antiAliasWithSaveLayer,
                                                    elevation: 20,
                                                    child: Column(
                                                      children: [
                                                        ListTile(
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          5),
                                                          title: Text(snapshot
                                                              .data!.docs[index]
                                                              .data()["name"]),
                                                          subtitle: Text(snapshot3
                                                                  .data!
                                                                  .docs[generate]
                                                                  .data()[
                                                              "dateTime"]),
                                                          leading: CircleAvatar(
                                                            backgroundImage:
                                                                NetworkImage(snapshot
                                                                        .data!
                                                                        .docs[index]
                                                                        .data()[
                                                                    "profileImg"]),
                                                            radius: 24,
                                                          ),
                                                          trailing: IconButton(
                                                            icon: Icon(Icons
                                                                .more_horiz),
                                                            onPressed: () {},
                                                          ),
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: SizedBox(
                                                            width:
                                                                double.infinity,
                                                            child: Text(
                                                              snapshot3
                                                                      .data!
                                                                      .docs[
                                                                          generate]
                                                                      .data()[
                                                                  "description"],
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .subtitle1,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: Card(
                                                            clipBehavior: Clip
                                                                .antiAliasWithSaveLayer,
                                                            child:
                                                                Image.network(
                                                              snapshot3
                                                                      .data!
                                                                      .docs[
                                                                          generate]
                                                                      .data()[
                                                                  "postImage"],
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: Row(
                                                            children: [
                                                              Icon(Icons
                                                                  .favorite_outline),
                                                              Text(snapshot2
                                                                  .data!
                                                                  .docs
                                                                  .length
                                                                  .toString()),
                                                              Spacer(),
                                                              Icon(Icons
                                                                  .add_comment_outlined),
                                                              Text("100")
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10),
                                                          child: Divider(
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: Row(
                                                            children: [
                                                              CircleAvatar(
                                                                backgroundImage: NetworkImage(Provider.of<
                                                                            MyProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .socialUser!
                                                                    .profileImg),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                  "Write comments ..."),
                                                              Spacer(),
                                                              InkWell(
                                                                onTap: () {
                                                                  Provider.of<MyProvider>(context, listen: false).likePost(
                                                                      snapshot3
                                                                          .data!
                                                                          .docs[
                                                                              generate]
                                                                          .id,
                                                                      snapshot
                                                                          .data!
                                                                          .docs[
                                                                              index]
                                                                          .id);
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    snapshot2.data!.docs.length !=
                                                                                0 &&
                                                                            snapshot2.data!.docs[0].data()[
                                                                                "like"]
                                                                        ? Icon(
                                                                            Icons.favorite,
                                                                            color:
                                                                                Colors.red,
                                                                          )
                                                                        : Icon(Icons
                                                                            .favorite_border_outlined),
                                                                    Text(
                                                                        "Like"),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                });
                                          } else {
                                            return SizedBox();
                                          }
                                        });
                                  } else {
                                    return SizedBox();
                                  }
                                });
                          }
                        });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
