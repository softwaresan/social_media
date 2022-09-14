import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:social_media/src/controller/myProvider.dart';
import 'package:social_media/src/screen/addNewVideo.dart';
import 'package:social_media/src/screen/myChats.dart';
import 'package:social_media/src/screen/testFile.dart';
import 'package:social_media/src/screen/videoShowScreen.dart';

import '../controller/pushNotificationViaRestApi.dart';

class HomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    Color tempColor = Provider.of<MyProvider>(context).currentIndex == 2
        ? Colors.white
        : Theme.of(context).primaryColor;

    if (Provider.of<MyProvider>(context).isLoading) {
      Provider.of<MyProvider>(context, listen: false).getUserData();

      return CircularProgressIndicator();
    } else {
      return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            extendBodyBehindAppBar:
                Provider.of<MyProvider>(context).currentIndex == 2
                    ? true
                    : false,
            extendBody: Provider.of<MyProvider>(context).currentIndex == 2
                ? true
                : false,
            backgroundColor: Provider.of<MyProvider>(context).currentIndex == 2
                ? Colors.transparent
                : Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor:
                  Provider.of<MyProvider>(context).currentIndex == 2
                      ? Colors.transparent
                      : Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              title: Provider.of<MyProvider>(context).currentIndex == 2
                  ? Text("Home", style: TextStyle(color: Colors.white))
                  : Text("Home", style: Theme.of(context).textTheme.subtitle1),
              actions: [
                IconButton(
                    onPressed: () {
                      Provider.of<MyProvider>(context, listen: false).isChat =
                          true;
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MyChats();
                      }));
                    },
                    icon: Icon(
                      Icons.chat,
                      color: tempColor,
                    )),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddNewVideo()));
                    },
                    icon: Icon(
                      Icons.videocam,
                      color: tempColor,
                    ))
              ],
            ),
            body: Provider.of<MyProvider>(context, listen: false).socialUser !=
                    null
                ? Provider.of<MyProvider>(context)
                    .screens[Provider.of<MyProvider>(context).currentIndex]
                : CircularProgressIndicator(),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor:
                  Provider.of<MyProvider>(context).currentIndex == 2
                      ? Colors.transparent
                      : Theme.of(context).scaffoldBackgroundColor,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              currentIndex: Provider.of<MyProvider>(context).currentIndex,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                Provider.of<MyProvider>(context, listen: false)
                    .changeScreen(index);
              },
              items: [
                BottomNavigationBarItem(
                    icon: GestureDetector(
                        child: Icon(
                      Icons.home,
                      color: tempColor,
                    )),
                    label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.search,
                      color: tempColor,
                    ),
                    label: "Search"),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.ondemand_video_sharp,
                      size: 35,
                      color: tempColor,
                    ),
                    label: "Reel"),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.account_circle,
                      color: tempColor,
                    ),
                    label: "Profile"),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.settings,
                      color: tempColor,
                    ),
                    label: "settings")
              ],
            )),
      );
    }
  }

  // Widget? _showBottomSheet(context) {
  //   if (Provider.of<MyProvider>(context, listen: false).showBottomSheet) {
  //     return BottomSheet(
  //       enableDrag: false,
  //       onClosing: () {},
  //       builder: (context) {
  //         return Container(
  //           height: 200,
  //           width: double.infinity,
  //           color: Colors.grey.shade200,
  //           alignment: Alignment.center,
  //           child: ElevatedButton(
  //             child: Text("Close Bottom Sheet"),
  //             style: ElevatedButton.styleFrom(
  //               onPrimary: Colors.white,
  //               primary: Colors.green,
  //             ),
  //             onPressed: () {
  //               Provider.of<MyProvider>(context, listen: false)
  //                   .showBottomSheetFunction();
  //             },
  //           ),
  //         );
  //       },
  //     );
  //   } else {
  //     return null;
  //   }
  // }
}
