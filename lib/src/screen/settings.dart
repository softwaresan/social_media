import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:social_media/main.dart';
import 'package:social_media/src/controller/myProvider.dart';
import 'package:social_media/src/screen/sign_in_screen.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        await Provider.of<MyProvider>(context, listen: false).userSignOut();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return SignIn();
        }));
      },
      child: Text("signout"),
    );
  }
}
