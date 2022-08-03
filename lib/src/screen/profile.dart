import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:social_media/src/screen/editProfileScreen.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Stack(
          alignment: AlignmentDirectional.center,
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Image.network(
                "https://images.unsplash.com/photo-1530878955558-a6c31b9c97db?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8bmljZXxlbnwwfHwwfHw%3D&w=1000&q=80",
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              top: 120,
              child: CircleAvatar(
                  radius: 62,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                        "https://i.pinimg.com/736x/5b/ad/9b/5bad9bd6915b96afddd0f5e85ddb8656.jpg"),
                  )),
            )
          ]),
      SizedBox(height: 50),
      Text("San Samir Boya", style: Theme.of(context).textTheme.subtitle1),
      SizedBox(height: 5),
      Text("this is my bio", style: Theme.of(context).textTheme.caption),
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
