import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:social_media/src/controller/myProvider.dart';
import 'package:social_media/src/model/social_user_model.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
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
                    .collection("publicPosts")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData) {
                    return Text("There is no posts for now");
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) => Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 20,
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 5),
                              title: Text(snapshot.data!.docs[index]
                                  .data()["userName"]),
                              subtitle: Text(snapshot.data!.docs[index]
                                  .data()["dateTime"]),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(snapshot
                                    .data!.docs[index]
                                    .data()["profileImg"]),
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
                                  snapshot.data!.docs[index]
                                      .data()["description"],
                                  style: Theme.of(context).textTheme.subtitle1,
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
                                  snapshot.data!.docs[index]
                                      .data()["postImage"],
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  Icon(Icons.favorite_outline),
                                  Text("120"),
                                  Spacer(),
                                  Icon(Icons.add_comment_outlined),
                                  Text("100")
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
                                        Provider.of<MyProvider>(context)
                                            .socialUser!
                                            .profileImg),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("Write comments ..."),
                                  Spacer(),
                                  Icon(Icons.favorite_outline),
                                  Text("Like"),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
