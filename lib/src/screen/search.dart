import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:social_media/src/controller/myProvider.dart';
import 'package:social_media/src/model/social_user_model.dart';
import 'package:social_media/src/screen/chatScreen.dart';
import 'package:social_media/src/screen/viewProfile.dart';

class Search extends StatefulWidget {
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    print("object");
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                color: Colors.grey[300],
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {});

                    Provider.of<MyProvider>(context, listen: false).userSearch =
                        value;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                      hintText: "Search"),
                )),
          ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream:
                  FirebaseFirestore.instance.collection("users").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  List<dynamic> searchList = [];
                  snapshot.data!.docs.forEach((e) {
                    if (e["name"].toLowerCase().contains(
                            Provider.of<MyProvider>(context, listen: false)
                                .userSearch!
                                .toLowerCase()) &&
                        Provider.of<MyProvider>(context, listen: false)
                                .userSearch !=
                            "" &&
                        e["name"] !=
                            Provider.of<MyProvider>(context, listen: false)
                                .socialUser!
                                .name) {
                      searchList.add(e);
                    }
                  });

                  return searchList.length > 0
                      ? ListView.separated(
                          separatorBuilder: (context, index) => SizedBox(
                            height: 10,
                          ),
                          shrinkWrap: true,
                          itemCount: searchList.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ViewProfile(
                                  friendUser: searchList[index],
                                );
                              }));
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 28,
                                backgroundImage: NetworkImage(
                                    searchList[index]["profileImg"]),
                              ),
                              title: Text(searchList[index]["name"]),
                            ),
                          ),
                        )
                      : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collectionGroup("myPosts")
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snapshot2) {
                            if (snapshot2.connectionState ==
                                ConnectionState.waiting) {
                              return SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  child: Center(
                                      child: CircularProgressIndicator()));
                            } else {
                              return SizedBox(
                                child: GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot2.data!.docs.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 4,
                                            mainAxisSpacing: 5),
                                    itemBuilder: (context, index) {
                                      return Image.network(
                                        snapshot2.data!.docs[index]
                                            .data()["postImage"],
                                        fit: BoxFit.fill,
                                      );
                                    }),
                              );
                            }
                          });
                }
              })
        ],
      ),
    );
  }
}
