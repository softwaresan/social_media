import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:social_media/src/controller/myProvider.dart';
import 'package:social_media/src/model/social_user_model.dart';
import 'package:social_media/src/screen/editProfileScreen.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SocialUser? _socialUser =
        Provider.of<MyProvider>(context, listen: false).socialUser!;

    return Column(children: [
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
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(_socialUser.profileImg),
                  )),
            )
          ]),
      SizedBox(height: 50),
      Text(_socialUser.name, style: Theme.of(context).textTheme.subtitle1),
      SizedBox(height: 5),
      Text(_socialUser.bio, style: Theme.of(context).textTheme.caption),
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Posts", style: Theme.of(context).textTheme.subtitle1),
          Text("Followers", style: Theme.of(context).textTheme.subtitle1),
          Text("Followings", style: Theme.of(context).textTheme.subtitle1),
        ],
      ),
      SizedBox(height: 10),
      Row(children: [
        Expanded(
            child: ElevatedButton(
                onPressed: () {},
                child: Text("ADD PHOTO", style: TextStyle(color: Colors.blue)),
                style: ElevatedButton.styleFrom(primary: Colors.white))),
        ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return EditProfile();
              }));
            },
            child: Icon(Icons.edit, color: Colors.blue),
            style: ElevatedButton.styleFrom(primary: Colors.white))
      ])
    ]);
  }
}
