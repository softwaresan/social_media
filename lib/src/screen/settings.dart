import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:social_media/main.dart';
import 'package:social_media/src/controller/myProvider.dart';
import 'package:social_media/src/screen/sign_in_screen.dart';

import '../controller/themeProvider.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () async {
            await Provider.of<MyProvider>(context, listen: false).userSignOut();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return SignIn();
            }));
          },
          child: Container(
            child: Center(
                child: Text(
              "signout",
              style: Theme.of(context).textTheme.bodyLarge,
            )),
            width: 200,
            height: 50,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: !Provider.of<ThemeProvider>(context).isDarkMode
                        ? [
                            Color.fromARGB(255, 255, 248, 185),
                            Color.fromARGB(255, 252, 227, 1)
                          ]
                        : [
                            Color.fromARGB(255, 233, 185, 241),
                            Color.fromARGB(255, 138, 3, 161),
                          ]),
                color: Colors.red,
                borderRadius: BorderRadius.circular(30)),
          ),
        ),
        FlutterSwitch(
          switchBorder: Border(
              top: BorderSide(),
              bottom: BorderSide(),
              right: BorderSide(),
              left: BorderSide()),
          activeToggleColor: Colors.black,
          activeColor: Colors.white,
          value: !Provider.of<ThemeProvider>(context).isDarkMode,
          inactiveIcon: Icon(
            Icons.nightlight_round_sharp,
            color: Colors.white,
          ),
          inactiveColor: Colors.purple,
          inactiveToggleColor: Colors.deepPurple,
          onToggle: (value) {
            Provider.of<ThemeProvider>(context, listen: false)
                .changeThemeMode();
          },
          activeIcon: Icon(
            Icons.light_mode,
            color: Colors.yellow,
          ),
        ),
      ],
    );
  }
}
