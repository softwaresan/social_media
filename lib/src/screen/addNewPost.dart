import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:social_media/main.dart';
import 'package:social_media/src/controller/myProvider.dart';
import 'package:social_media/src/model/social_user_model.dart';

import '../controller/themeProvider.dart';

class AddNewPost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SocialUser socialUser = Provider.of<MyProvider>(context).socialUser!;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            Provider.of<MyProvider>(context, listen: false).newPostPath = null;
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        title: Text(
          "Add New Post",
          style: Theme.of(context).textTheme.headline6,
        ),
        actions: [
          TextButton(
              onPressed: () {
                Provider.of<MyProvider>(context, listen: false)
                    .uploadNewPost(context);
              },
              child: Text("POST"))
        ],
      ),
      body: Column(
        children: [
          Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(socialUser.profileImg),
                ),
                title: Text(socialUser.name),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Container(
                  color: Provider.of<ThemeProvider>(context, listen: false)
                          .isDarkMode
                      ? Colors.grey[800]
                      : Colors.grey[300],
                  child: TextFormField(
                      controller: Provider.of<MyProvider>(context).description,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'What is on your mind',
                      )),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
                child: Provider.of<MyProvider>(context).newPostPath != null
                    ? Image.file(
                        File(
                          Provider.of<MyProvider>(context).newPostPath!,
                        ),
                        fit: BoxFit.fill,
                      )
                    : Icon(Icons.image_not_supported_sharp)),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      Provider.of<MyProvider>(context, listen: false)
                          .newPostFromCamera();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          color: Colors.blue,
                        ),
                        Text("CAMERA", style: TextStyle(color: Colors.blue)),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                        primary:
                            Provider.of<ThemeProvider>(context, listen: false)
                                    .isDarkMode
                                ? Colors.grey[800]
                                : Colors.grey[200])),
              ),
              Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      Provider.of<MyProvider>(context, listen: false)
                          .newPostFromGallery();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo,
                          color: Colors.blue,
                        ),
                        Text("GALLERY", style: TextStyle(color: Colors.blue)),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                        primary:
                            Provider.of<ThemeProvider>(context, listen: false)
                                    .isDarkMode
                                ? Colors.grey[800]
                                : Colors.grey[200])),
              )
            ],
          )
        ],
      ),
    ));
  }
}
