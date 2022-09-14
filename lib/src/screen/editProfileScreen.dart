import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:social_media/src/controller/myProvider.dart';
import 'package:social_media/src/controller/themeProvider.dart';
import 'package:social_media/src/model/social_user_model.dart';
import 'package:social_media/src/widgets/customTextField.dart';

class EditProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SocialUser? _socialUser = Provider.of<MyProvider>(context).socialUser!;
    return SafeArea(
        child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                titleSpacing: 5,
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_outlined,
                        color: Theme.of(context).primaryColor)),
                title: Text("EDIT PROFILE",
                    style: Theme.of(context).textTheme.subtitle1),
                actions: [
                  TextButton(
                      onPressed: () {
                        Provider.of<MyProvider>(context, listen: false)
                            .updateUserProfile(context);
                      },
                      child: Text(
                        "UPDATE",
                        style: TextStyle(color: Colors.lightBlueAccent),
                      )),
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
                          backgroundColor:
                              Provider.of<ThemeProvider>(context, listen: false)
                                      .isDarkMode
                                  ? Theme.of(context).scaffoldBackgroundColor
                                  : Colors.white,
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
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomTextField(
                        hint: "New Name",
                        prefixIcon: Icons.person,
                        newController:
                            Provider.of<MyProvider>(context).nameController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomTextField(
                        hint: "New Phone Number",
                        prefixIcon: Icons.phone,
                        newController:
                            Provider.of<MyProvider>(context).phoneController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomTextField(
                        hint: "New Bio",
                        prefixIcon: Icons.question_mark_outlined,
                        newController:
                            Provider.of<MyProvider>(context).bioController,
                      ),
                    )
                  ],
                ),
              )
            ])));
  }
}
