import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                titleSpacing: 5,
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_outlined, color: Colors.black)),
                title: Text("EDIT PROFILE",
                    style: Theme.of(context).textTheme.subtitle1),
                actions: [
                  TextButton(onPressed: () {}, child: Text("UPDATE")),
                  SizedBox(width: 10)
                ]),
            body: Column(children: [
              Stack(clipBehavior: Clip.none, children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Image.network(
                    "https://images.unsplash.com/photo-1530878955558-a6c31b9c97db?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8bmljZXxlbnwwfHwwfHw%3D&w=1000&q=80",
                    fit: BoxFit.fill,
                  ),
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: CircleAvatar(child: Icon(Icons.camera_alt))),
                Positioned(
                  top: 120,
                  left: 140,
                  child: Stack(alignment: Alignment.bottomRight, children: [
                    CircleAvatar(
                        radius: 65,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(
                              "https://i.pinimg.com/736x/5b/ad/9b/5bad9bd6915b96afddd0f5e85ddb8656.jpg"),
                        )),
                    CircleAvatar(
                      child: Icon(Icons.camera_alt),
                    )
                  ]),
                )
              ]),
            ])));
  }
}
