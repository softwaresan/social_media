import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:social_media/src/controller/myProvider.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({required this.friendUser});
  var friendUser;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              titleSpacing: -25,
              elevation: 1,
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  )),
              title: ListTile(
                horizontalTitleGap: 10,
                leading: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(friendUser["profileImg"]),
                ),
                title: Text(friendUser["name"]),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .doc(Provider.of<MyProvider>(context, listen: false)
                                .socialUser!
                                .uid)
                            .collection("chats")
                            .doc(friendUser["uid"])
                            .collection("messages")
                            .orderBy("dateTime", descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text("no messages");
                          } else {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: ListView.builder(
                                reverse: true,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return snapshot.data!.docs[index]
                                              .data()["senderId"] !=
                                          Provider.of<MyProvider>(context,
                                                  listen: false)
                                              .socialUser!
                                              .uid
                                      ? Align(
                                          alignment:
                                              AlignmentDirectional.centerStart,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    15),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    15),
                                                            topRight:
                                                                Radius.circular(
                                                                    15))),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                    snapshot.data!.docs[index]
                                                        .data()["textMsg"],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle1,
                                                  ),
                                                )),
                                          ),
                                        )
                                      : Align(
                                          alignment:
                                              AlignmentDirectional.centerEnd,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color:
                                                        Colors.lightBlueAccent,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    15),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    15),
                                                            topRight:
                                                                Radius.circular(
                                                                    15))),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                    snapshot.data!.docs[index]
                                                        .data()["textMsg"],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle1,
                                                  ),
                                                )),
                                          ),
                                        );
                                },
                              ),
                            );
                          }
                        })),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: TextFormField(
                      onFieldSubmitted: (value) {
                        if (Provider.of<MyProvider>(context, listen: false)
                                .messageController
                                .text
                                .trim() !=
                            "")
                          Provider.of<MyProvider>(context, listen: false)
                              .sendMessages(
                                  receiverId: friendUser["uid"],
                                  dateTime: DateTime.now().toString(),
                                  textMsg: Provider.of<MyProvider>(context,
                                          listen: false)
                                      .messageController
                                      .text);
                      },
                      controller:
                          Provider.of<MyProvider>(context, listen: false)
                              .messageController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          suffixIcon: IconButton(
                              onPressed: () {
                                if (Provider.of<MyProvider>(context,
                                            listen: false)
                                        .messageController
                                        .text
                                        .trim() !=
                                    "")
                                  Provider.of<MyProvider>(context,
                                          listen: false)
                                      .sendMessages(
                                          receiverId: friendUser["uid"],
                                          dateTime: DateTime.now().toString(),
                                          textMsg: Provider.of<MyProvider>(
                                                  context,
                                                  listen: false)
                                              .messageController
                                              .text);
                              },
                              icon: Icon(Icons.send)),
                          label: Text("MESSAGE"),
                          floatingLabelBehavior: FloatingLabelBehavior.never),
                    ),
                  ),
                )
              ],
            )));
  }
}
