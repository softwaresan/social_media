import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:social_media/src/controller/myProvider.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                if (!snapshot.hasData) {
                  return Text("no data");
                } else {
                  List<dynamic> searchList = [];
                  snapshot.data!.docs.forEach((e) {
                    if (e["name"].toLowerCase().contains(
                            Provider.of<MyProvider>(context)
                                .userSearch!
                                .toLowerCase()) &&
                        Provider.of<MyProvider>(context).userSearch != "") {
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
                          itemBuilder: (context, index) => ListTile(
                            leading: CircleAvatar(
                              radius: 28,
                              backgroundImage:
                                  NetworkImage(searchList[index]["profileImg"]),
                            ),
                            title: Text(searchList[index]["name"]),
                          ),
                        )
                      : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection("publicPosts")
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.data == null) {
                              return Center(child: Text("you have no post"));
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
                                        snapshot.data!.docs[index]
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
