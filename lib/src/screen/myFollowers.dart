// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:social_media/src/controller/myProvider.dart';
import 'package:social_media/src/screen/viewProfile.dart';

class MyFollowers extends StatelessWidget {
  var myFollowersUsers;
  MyFollowers({
    Key? key,
    required this.myFollowersUsers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon:
                Icon(Icons.arrow_back, color: Theme.of(context).primaryColor)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text("Followers",
            style: TextStyle(color: Theme.of(context).primaryColor)),
      ),
      body: myFollowersUsers.length == 0
          ? Center(
              child: Text(
                "There is no Followers",
                style: TextStyle(color: Colors.black),
              ),
            )
          : ListView.builder(
              itemCount: myFollowersUsers.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewProfile(
                              friendUser: myFollowersUsers[index],
                              isFollowed: true,
                            ))),
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundImage:
                          NetworkImage(myFollowersUsers[index]["profileImg"]),
                    ),
                    title: Text(myFollowersUsers[index]["name"]),
                  ),
                ),
              ),
            ),
    ));
  }
}
