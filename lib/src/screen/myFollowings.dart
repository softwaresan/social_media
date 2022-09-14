import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:social_media/src/controller/myProvider.dart';
import 'package:social_media/src/screen/viewProfile.dart';

class MyFollowings extends StatelessWidget {
  var myFollowingsUsers;
  MyFollowings({
    Key? key,
    required this.myFollowingsUsers,
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
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).primaryColor,
            )),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text("Followings",
            style: TextStyle(color: Theme.of(context).primaryColor)),
      ),
      body: myFollowingsUsers.length == 0
          ? Center(
              child: Text(
                "There is no Followings",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            )
          : ListView.builder(
              itemCount: myFollowingsUsers.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    print(myFollowingsUsers[index]["name"]);

                    return ViewProfile(
                      friendUser: myFollowingsUsers[index],
                      isFollowed: true,
                    );
                  })),
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    elevation: 2,
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(
                            myFollowingsUsers[index]["profileImg"]),
                      ),
                      title: Text(myFollowingsUsers[index]["name"]),
                    ),
                  ),
                );
              },
            ),
    ));
  }
}
