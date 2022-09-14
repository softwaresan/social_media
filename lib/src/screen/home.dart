import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:social_media/src/controller/myProvider.dart';
import 'package:social_media/src/screen/ViewPost.dart';
import 'package:social_media/src/screen/addNewStory.dart';
import 'package:social_media/src/screen/showStory.dart';
import 'package:social_media/src/screen/viewProfile.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return ConditionalBuilder(
        condition: Provider.of<MyProvider>(context).posts.isNotEmpty ||
            !Provider.of<MyProvider>(context).isPosts,
        fallback: (context) {
          Future.delayed(Duration.zero, () async {
            await Provider.of<MyProvider>(context, listen: false).getPosts();
            Provider.of<MyProvider>(context, listen: false).getStories();
          });

          return CircularProgressIndicator();
        },
        builder: (context) {
          return RefreshIndicator(
            onRefresh: () async {
              await Provider.of<MyProvider>(context, listen: false).getPosts();
              return Provider.of<MyProvider>(context, listen: false)
                  .getStories();
            },
            child: ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.13,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                height: 66,
                                width: 66,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                              ),
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                    Provider.of<MyProvider>(context,
                                            listen: false)
                                        .socialUser!
                                        .profileImg),
                                radius: 30,
                              ),
                              InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddNewStory(),
                                    )),
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Colors.lightBlueAccent,
                                      child: FittedBox(
                                          child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ))),
                                ),
                              )
                            ],
                          ),
                          Text("Add Story")
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ShowStory(
                                            stories: Provider.of<MyProvider>(
                                                    context,
                                                    listen: false)
                                                .stories[index]),
                                      )),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        height: 66,
                                        width: 66,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                begin: Alignment.bottomLeft,
                                                end: Alignment.topRight,
                                                colors: [
                                                  Colors.yellow,
                                                  Colors.orange,
                                                  Colors.red,
                                                  Colors.pink
                                                ]),
                                            shape: BoxShape.circle,
                                            color: Colors.red),
                                      ),
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                            Provider.of<MyProvider>(context,
                                                        listen: false)
                                                    .storyUser[index]
                                                ["profileImg"]),
                                      )
                                    ],
                                  ),
                                ),
                                Text(Provider.of<MyProvider>(context,
                                        listen: false)
                                    .storyUser[index]["name"])
                              ],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              width: 10,
                            );
                          },
                          itemCount:
                              Provider.of<MyProvider>(context, listen: false)
                                  .storyUser
                                  .length),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: Provider.of<MyProvider>(context).posts.length,
                  itemBuilder: (context, index) {
                    return Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 20,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ViewProfile(
                                    friendUser: Provider.of<MyProvider>(context)
                                        .users[index],
                                    isFollowed: true);
                              }));
                            },
                            child: ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 5),
                              title: Text(Provider.of<MyProvider>(context)
                                  .users[index]
                                  .data()["name"]),
                              subtitle: Text(DateFormat.yMd().add_jm().format(
                                  DateTime.parse(
                                      Provider.of<MyProvider>(context)
                                          .posts[index]
                                          .data()["dateTime"]))),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    Provider.of<MyProvider>(context)
                                        .users[index]
                                        .data()["profileImg"]),
                                radius: 24,
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.more_horiz),
                                onPressed: () {},
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.grey,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return Viewpost(
                                  postId: Provider.of<MyProvider>(context)
                                      .posts[index]
                                      .data()["postId"],
                                  userId: Provider.of<MyProvider>(context)
                                      .posts[index]
                                      .data()["uId"],
                                  dateTime: Provider.of<MyProvider>(context)
                                      .posts[index]
                                      .data()["dateTime"],
                                  numberOfLikes:
                                      Provider.of<MyProvider>(context)
                                          .likes[index],
                                  profileImg: Provider.of<MyProvider>(context)
                                      .users[index]
                                      .data()["profileImg"],
                                  name: Provider.of<MyProvider>(context)
                                      .users[index]
                                      .data()["name"],
                                  description: Provider.of<MyProvider>(context)
                                      .posts[index]
                                      .data()["description"],
                                  postImg: Provider.of<MyProvider>(context)
                                      .posts[index]
                                      .data()["postImage"],
                                  isLiked: Provider.of<MyProvider>(context)
                                      .isLiked[index],
                                  commentsNo: Provider.of<MyProvider>(context)
                                      .comments[index],
                                );
                              }));
                            },
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      Provider.of<MyProvider>(context)
                                          .posts[index]
                                          .data()["description"],
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
                                      Provider.of<MyProvider>(context)
                                          .posts[index]
                                          .data()["postImage"],
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    children: [
                                      (Provider.of<MyProvider>(context)
                                              .isLiked[index]
                                          ? Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                            )
                                          : Icon(Icons.favorite_outline)),
                                      Text(" " +
                                          Provider.of<MyProvider>(context)
                                              .likes[index]
                                              .toString() +
                                          " Likes"),
                                      Spacer(),
                                      Row(
                                        children: [
                                          Icon(Icons.add_comment_outlined),
                                          Text(" " +
                                              Provider.of<MyProvider>(context)
                                                  .comments[index]
                                                  .toString() +
                                              " Comments"),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                    child: TextField(
                                      controller: Provider.of<MyProvider>(
                                              context,
                                              listen: false)
                                          .commentController,
                                      onSubmitted: (value) {
                                        Provider.of<MyProvider>(context,
                                                listen: false)
                                            .commentPost(
                                                Provider.of<MyProvider>(context,
                                                        listen: false)
                                                    .posts[index]
                                                    .data()["postId"],
                                                Provider.of<MyProvider>(context,
                                                        listen: false)
                                                    .posts[index]
                                                    .data()["uId"],
                                                "myPosts");
                                      },
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
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
                                        .likePost(
                                            Provider.of<MyProvider>(context,
                                                    listen: false)
                                                .posts[index]
                                                .data()["postId"],
                                            Provider.of<MyProvider>(context,
                                                    listen: false)
                                                .posts[index]
                                                .data()["uId"],
                                            Provider.of<MyProvider>(context,
                                                    listen: false)
                                                .isLiked[index],
                                            "myPosts");

                                    if (Provider.of<MyProvider>(context,
                                            listen: false)
                                        .isLiked[index]) {
                                      Provider.of<MyProvider>(context,
                                                  listen: false)
                                              .isLiked[index] =
                                          !Provider.of<MyProvider>(context,
                                                  listen: false)
                                              .isLiked[index];
                                      Provider.of<MyProvider>(context,
                                              listen: false)
                                          .likes[index]--;
                                    } else {
                                      Provider.of<MyProvider>(context,
                                                  listen: false)
                                              .isLiked[index] =
                                          !Provider.of<MyProvider>(context,
                                                  listen: false)
                                              .isLiked[index];
                                      Provider.of<MyProvider>(context,
                                              listen: false)
                                          .likes[index]++;
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      (Provider.of<MyProvider>(context)
                                              .isLiked[index]
                                          ? Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                            )
                                          : Icon(Icons.favorite_outline)),
                                      Text("Like"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        });
  }
}




//////////////////////////////////////////////////////////////////////////////////////////public posts////////////////////////////////////
// import 'dart:math';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:provider/provider.dart';
// import 'package:social_media/src/controller/myProvider.dart';
// import 'package:social_media/src/model/social_user_model.dart';
// import 'package:social_media/src/screen/ViewPost.dart';

// class Home extends StatefulWidget {
//   const Home({Key? key}) : super(key: key);

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(5.0),
//       child: RefreshIndicator(
//         onRefresh: () {
//           setState(() {});
//           return Future.delayed(Duration(milliseconds: 500));
//         },
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Card(
//                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                 elevation: 20,
//                 child: Image.network(
//                   "https://img.freepik.com/free-vector/young-people-standing-talking-each-other-speech-bubble-smartphone-girl-flat-vector-illustration-communication-discussion_74855-8741.jpg",
//                   fit: BoxFit.fill,
//                 ),
//               ),
//               StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//                   stream: FirebaseFirestore.instance
//                       .collection("users")
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return Center(child: CircularProgressIndicator());
//                     } else if (snapshot.data == null) {
//                       return Text("There is no posts for now");
//                     } else if (snapshot.hasError) {
//                       return Text("erro");
//                     } else {
//                       return ListView.builder(
//                           shrinkWrap: true,
//                           physics: NeverScrollableScrollPhysics(),
//                           itemCount: snapshot.data!.docs.length,
//                           itemBuilder: (context, index) {
//                             if (index < snapshot.data!.docs.length) {
//                               return StreamBuilder<
//                                       QuerySnapshot<Map<String, dynamic>>>(
//                                   stream: FirebaseFirestore.instance
//                                       .collection("users")
//                                       .doc(snapshot.data!.docs[index].id)
//                                       .collection("myPosts")
//                                       .orderBy("dateTime", descending: true)
//                                       .snapshots(),
//                                   builder: (context, snapshot3) {
//                                     if (snapshot3.connectionState ==
//                                         ConnectionState.waiting) {
//                                       return CircularProgressIndicator();
//                                     } else if (snapshot3.data!.docs.length !=
//                                         0) {
//                                       int generate = 0;

//                                       return StreamBuilder<
//                                               QuerySnapshot<
//                                                   Map<String, dynamic>>>(
//                                           stream: FirebaseFirestore.instance
//                                               .collection("users")
//                                               .doc(
//                                                   snapshot.data!.docs[index].id)
//                                               .collection("myPosts")
//                                               .doc(snapshot3
//                                                   .data!.docs[generate].id)
//                                               .collection("likes")
//                                               .snapshots(),
//                                           builder: (context, snapshot2) {
//                                             if (snapshot2.connectionState ==
//                                                 ConnectionState.waiting) {
//                                               return CircularProgressIndicator();
//                                             }

//                                             return Card(
//                                               clipBehavior:
//                                                   Clip.antiAliasWithSaveLayer,
//                                               elevation: 20,
//                                               child: Column(
//                                                 children: [
//                                                   ListTile(
//                                                     contentPadding:
//                                                         EdgeInsets.symmetric(
//                                                             horizontal: 5),
//                                                     title: Text(snapshot
//                                                         .data!.docs[index]
//                                                         .data()["name"]),
//                                                     subtitle: Text(snapshot3
//                                                         .data!.docs[generate]
//                                                         .data()["dateTime"]),
//                                                     leading: CircleAvatar(
//                                                       backgroundImage:
//                                                           NetworkImage(snapshot
//                                                                   .data!
//                                                                   .docs[index]
//                                                                   .data()[
//                                                               "profileImg"]),
//                                                       radius: 24,
//                                                     ),
//                                                     trailing: IconButton(
//                                                       icon: Icon(
//                                                           Icons.more_horiz),
//                                                       onPressed: () {},
//                                                     ),
//                                                   ),
//                                                   Divider(
//                                                     color: Colors.grey,
//                                                   ),
//                                                   Padding(
//                                                     padding:
//                                                         const EdgeInsets.all(
//                                                             5.0),
//                                                     child: SizedBox(
//                                                       width: double.infinity,
//                                                       child: Text(
//                                                         snapshot3.data!
//                                                                 .docs[generate]
//                                                                 .data()[
//                                                             "description"],
//                                                         style: Theme.of(context)
//                                                             .textTheme
//                                                             .subtitle1,
//                                                         textAlign:
//                                                             TextAlign.left,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     height: 10,
//                                                   ),
//                                                   SizedBox(
//                                                     width: double.infinity,
//                                                     child: Card(
//                                                       clipBehavior: Clip
//                                                           .antiAliasWithSaveLayer,
//                                                       child: Image.network(
//                                                         snapshot3.data!
//                                                                 .docs[generate]
//                                                                 .data()[
//                                                             "postImage"],
//                                                         fit: BoxFit.fill,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   Padding(
//                                                     padding:
//                                                         const EdgeInsets.all(
//                                                             5.0),
//                                                     child: Row(
//                                                       children: [
//                                                         Icon(Icons
//                                                             .favorite_outline),
//                                                         Text(snapshot2
//                                                             .data!.docs.length
//                                                             .toString()),
//                                                         Spacer(),
//                                                         InkWell(
//                                                           onTap: () {
//                                                             Navigator.push(
//                                                                 context,
//                                                                 MaterialPageRoute(
//                                                                     builder:
//                                                                         (context) =>
//                                                                             Viewpost(
//                                                                               postImg: snapshot3.data!.docs[generate].data()["postImage"],
//                                                                               description: snapshot3.data!.docs[generate].data()["description"],
//                                                                               name: snapshot.data!.docs[index].data()["name"],
//                                                                               postId: snapshot3.data!.docs[generate].id,
//                                                                               userId: snapshot.data!.docs[index].id,
//                                                                               numberOfLikes: snapshot2.data!.docs.length.toString(),
//                                                                               dateTime: snapshot3.data!.docs[generate].data()["dateTime"],
//                                                                               profileImg: snapshot.data!.docs[index].data()["profileImg"],
//                                                                             )));
//                                                           },
//                                                           child: Row(
//                                                             children: [
//                                                               Icon(Icons
//                                                                   .add_comment_outlined),
//                                                               Text("100"),
//                                                             ],
//                                                           ),
//                                                         )
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   Padding(
//                                                     padding: const EdgeInsets
//                                                             .symmetric(
//                                                         horizontal: 10),
//                                                     child: Divider(
//                                                       color: Colors.grey,
//                                                     ),
//                                                   ),
//                                                   Padding(
//                                                     padding:
//                                                         const EdgeInsets.all(
//                                                             5.0),
//                                                     child: Row(
//                                                       children: [
//                                                         CircleAvatar(
//                                                           backgroundImage:
//                                                               NetworkImage(Provider.of<
//                                                                           MyProvider>(
//                                                                       context,
//                                                                       listen:
//                                                                           false)
//                                                                   .socialUser!
//                                                                   .profileImg),
//                                                         ),
//                                                         SizedBox(
//                                                           width: 5,
//                                                         ),
//                                                         Expanded(
//                                                           child: Container(
//                                                             height: MediaQuery.of(
//                                                                         context)
//                                                                     .size
//                                                                     .height *
//                                                                 0.05,
//                                                             child: TextField(
//                                                               controller: Provider.of<
//                                                                           MyProvider>(
//                                                                       context,
//                                                                       listen:
//                                                                           false)
//                                                                   .commentController,
//                                                               onSubmitted:
//                                                                   (value) {
//                                                                 Provider.of<MyProvider>(
//                                                                         context,
//                                                                         listen:
//                                                                             false)
//                                                                     .commentPost(
//                                                                         snapshot3
//                                                                             .data!
//                                                                             .docs[
//                                                                                 generate]
//                                                                             .id,
//                                                                         snapshot
//                                                                             .data!
//                                                                             .docs[index]
//                                                                             .id);
//                                                               },
//                                                               decoration: InputDecoration(
//                                                                   border: OutlineInputBorder(
//                                                                       borderRadius:
//                                                                           BorderRadius.all(Radius.circular(
//                                                                               20))),
//                                                                   label: Text(
//                                                                       "Write A Comment"),
//                                                                   floatingLabelBehavior:
//                                                                       FloatingLabelBehavior
//                                                                           .never),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         InkWell(
//                                                           onTap: () {
//                                                             Provider.of<MyProvider>(
//                                                                     context,
//                                                                     listen:
//                                                                         false)
//                                                                 .likePost(
//                                                                     snapshot3
//                                                                         .data!
//                                                                         .docs[
//                                                                             generate]
//                                                                         .id,
//                                                                     snapshot
//                                                                         .data!
//                                                                         .docs[
//                                                                             index]
//                                                                         .id);
//                                                           },
//                                                           child: Row(
//                                                             children: [
//                                                               snapshot2.data!.docs
//                                                                               .length !=
//                                                                           0 &&
//                                                                       snapshot2
//                                                                           .data!
//                                                                           .docs[
//                                                                               0]
//                                                                           .data()["like"]
//                                                                   ? Icon(
//                                                                       Icons
//                                                                           .favorite,
//                                                                       color: Colors
//                                                                           .red,
//                                                                     )
//                                                                   : Icon(Icons.favorite_border_outlined),
//                                                               Text("Like"),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   )
//                                                 ],
//                                               ),
//                                             );
//                                           });
//                                     } else {
//                                       return SizedBox();
//                                     }
//                                   });
//                             } else {
//                               return SizedBox();
//                             }
//                           });
//                     }
//                   })
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
