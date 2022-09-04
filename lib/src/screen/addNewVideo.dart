import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:social_media/main.dart';
import 'package:social_media/src/controller/myProvider.dart';
import 'package:social_media/src/model/social_user_model.dart';
import 'package:video_player/video_player.dart';

class AddNewVideo extends StatefulWidget {
  @override
  State<AddNewVideo> createState() => _AddNewVideoState();
}

class _AddNewVideoState extends State<AddNewVideo> {
  VideoPlayerController _videoPlayerController =
      VideoPlayerController.network("");
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!Provider.of<MyProvider>(context, listen: false).isVideoPicked) {
      _videoPlayerController = VideoPlayerController.file(File(
          Provider.of<MyProvider>(context, listen: false).videoFile!.path));

      _videoPlayerController..initialize().then((value) {});

      Provider.of<MyProvider>(context, listen: false).isVideoPicked = true;
      setState(() {});
    }
    SocialUser socialUser = Provider.of<MyProvider>(context).socialUser!;
    return Builder(builder: (context) {
      _videoPlayerController.setLooping(true);
      _videoPlayerController.play();
      return SafeArea(
          child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              Provider.of<MyProvider>(context, listen: false).newPostPath =
                  null;
              Navigator.pop(context);
            },
          ),
          elevation: 0,
          title: Text(
            "Add New Video",
            style: Theme.of(context).textTheme.headline6,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Provider.of<MyProvider>(context, listen: false)
                      .shareVideo(context);
                },
                child: Text("SHARE"))
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
                    color: Colors.grey[300],
                    child: TextFormField(
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
                  child: Provider.of<MyProvider>(context).videoFile != null
                      ? VideoPlayer(_videoPlayerController)
                      : Icon(Icons.image_not_supported_sharp)),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        Provider.of<MyProvider>(context, listen: false)
                            .pickVideoFromCamera();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.videocam,
                            color: Colors.blue,
                          ),
                          Text("CAMERA", style: TextStyle(color: Colors.blue)),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(primary: Colors.white)),
                ),
                Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        Provider.of<MyProvider>(context, listen: false)
                            .pickVideoFromGallery();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.video_library,
                            color: Colors.blue,
                          ),
                          Text("GALLERY", style: TextStyle(color: Colors.blue)),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(primary: Colors.white)),
                )
              ],
            )
          ],
        ),
      ));
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _videoPlayerController.dispose();
    super.dispose();
  }
}
