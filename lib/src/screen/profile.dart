import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:social_media/src/controller/myProvider.dart';
import 'package:social_media/src/controller/themeProvider.dart';
import 'package:social_media/src/model/social_user_model.dart';
import 'package:social_media/src/screen/addNewPost.dart';
import 'package:social_media/src/screen/editProfileScreen.dart';
import 'package:social_media/src/screen/myFollowers.dart';
import 'package:social_media/src/screen/myFollowings.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int? _myPosts;
  int? _myFollowings;
  int? _myFollowers;
  var _myFollowingsUsers = [];
  var _myFollowersUsers = [];
  @override
  void initState() {
    super.initState();

    Provider.of<MyProvider>(context, listen: false).isMyAnalysisReady = false;
    Future.delayed(Duration.zero, () async {
      await Provider.of<MyProvider>(context, listen: false).getMyAnalysis(
          Provider.of<MyProvider>(context, listen: false).socialUser!.uid);
      _myPosts = Provider.of<MyProvider>(context, listen: false).myPosts;
      _myFollowings =
          Provider.of<MyProvider>(context, listen: false).myFollowings;
      _myFollowers =
          Provider.of<MyProvider>(context, listen: false).myFollowers;
      _myFollowingsUsers =
          Provider.of<MyProvider>(context, listen: false).myFollowingsUsers;
      _myFollowersUsers =
          Provider.of<MyProvider>(context, listen: false).myFollowersUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    SocialUser? _socialUser =
        Provider.of<MyProvider>(context, listen: false).socialUser!;
    if (Provider.of<MyProvider>(context).isLoading ||
        !Provider.of<MyProvider>(context, listen: false).isMyAnalysisReady) {
      _socialUser = Provider.of<MyProvider>(context, listen: false).socialUser!;
      return Center(child: CircularProgressIndicator());
    } else {
      return RefreshIndicator(
        onRefresh: () {
          setState(() {});

          return Future.delayed(Duration(seconds: 2), () {});
        },
        child: SingleChildScrollView(
          child: Column(children: [
            Stack(
                alignment: AlignmentDirectional.center,
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Image.network(
                      _socialUser.coverImg,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    top: 120,
                    child: CircleAvatar(
                        radius: 65,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(_socialUser.profileImg),
                        )),
                  )
                ]),
            SizedBox(height: 50),
            Text(_socialUser.name,
                style: Theme.of(context).textTheme.subtitle1),
            SizedBox(height: 5),
            Text(_socialUser.bio, style: Theme.of(context).textTheme.caption),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text("Posts", style: Theme.of(context).textTheme.subtitle1),
                    Text(_myPosts.toString(),
                        style: Theme.of(context).textTheme.subtitle1),
                  ],
                ),
                InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyFollowers(
                              myFollowersUsers: _myFollowersUsers))),
                  child: Column(
                    children: [
                      Text("Followers",
                          style: Theme.of(context).textTheme.subtitle1),
                      Text(_myFollowers.toString(),
                          style: Theme.of(context).textTheme.subtitle1)
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyFollowings(
                                myFollowingsUsers: _myFollowingsUsers)));
                  },
                  child: Column(
                    children: [
                      Text("Followings",
                          style: Theme.of(context).textTheme.subtitle1),
                      Text(_myFollowings.toString(),
                          style: Theme.of(context).textTheme.subtitle1)
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(children: [
              Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        Provider.of<MyProvider>(context, listen: false)
                            .description
                            .text = "";
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddNewPost()));
                      },
                      child: Text("ADD PHOTO",
                          style: TextStyle(
                              color: Provider.of<ThemeProvider>(context,
                                          listen: false)
                                      .isDarkMode
                                  ? Theme.of(context).primaryColor
                                  : Colors.blue)),
                      style: ElevatedButton.styleFrom(
                          primary:
                              Provider.of<ThemeProvider>(context, listen: false)
                                      .isDarkMode
                                  ? Colors.grey[800]
                                  : Colors.white))),
              ElevatedButton(
                  onPressed: () {
                    Provider.of<MyProvider>(context, listen: false)
                        .nameController
                        .text = _socialUser!.name;
                    Provider.of<MyProvider>(context, listen: false)
                        .bioController
                        .text = _socialUser.bio;
                    Provider.of<MyProvider>(context, listen: false)
                        .phoneController
                        .text = _socialUser.phone;
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return EditProfile();
                    }));
                  },
                  child: Icon(Icons.edit,
                      color: Provider.of<ThemeProvider>(context, listen: false)
                              .isDarkMode
                          ? Theme.of(context).primaryColor
                          : Colors.blue),
                  style: ElevatedButton.styleFrom(
                      primary:
                          Provider.of<ThemeProvider>(context, listen: false)
                                  .isDarkMode
                              ? Colors.grey[800]
                              : Colors.white))
            ]),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(_socialUser.uid)
                    .collection("myPosts")
                    .orderBy("dateTime", descending: true)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
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
}
