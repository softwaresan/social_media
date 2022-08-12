import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:social_media/src/controller/myProvider.dart';
import 'package:social_media/src/model/social_user_model.dart';

class EditProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SocialUser? _socialUser = Provider.of<MyProvider>(context).socialUser!;
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
                  TextButton(
                      onPressed: () {
                        Provider.of<MyProvider>(context, listen: false)
                            .updateUserProfile(context);
                      },
                      child: Text("UPDATE")),
                  SizedBox(width: 10)
                ]),
            body: Column(children: [
              SizedBox(
                height: 245,
                child:
                    Stack(alignment: AlignmentDirectional.topCenter, children: [
                  SizedBox(
                      height: 200,
                      width: double.infinity,
                      child:
                          Provider.of<MyProvider>(context).coverPicPath != null
                              ? Image.file(
                                  File(Provider.of<MyProvider>(context)
                                      .coverPicPath!),
                                  fit: BoxFit.fill,
                                )
                              : Image.network(
                                  _socialUser.coverImg,
                                  fit: BoxFit.fill,
                                )),
                  Align(
                      alignment: Alignment.topRight,
                      child: CircleAvatar(
                          child: IconButton(
                              onPressed: () {
                                Provider.of<MyProvider>(context, listen: false)
                                    .changeCoverPic();
                              },
                              icon: Icon(Icons.camera_alt)))),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Stack(alignment: Alignment.bottomRight, children: [
                      CircleAvatar(
                          radius: 65,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: Provider.of<MyProvider>(context)
                                        .profilePicPath !=
                                    null
                                ? FileImage(File(
                                    Provider.of<MyProvider>(context)
                                        .profilePicPath!))
                                : NetworkImage(_socialUser.profileImg)
                                    as ImageProvider,
                          )),
                      IconButton(
                        onPressed: () {
                          Provider.of<MyProvider>(context, listen: false)
                              .changeProfilePic();
                        },
                        icon: CircleAvatar(
                          child: Icon(Icons.camera_alt),
                        ),
                      )
                    ]),
                  )
                ]),
              ),
            ])));
  }
}
