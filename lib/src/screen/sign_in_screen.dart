import 'dart:io';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:images_picker/images_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_media/src/controller/myProvider.dart';
import 'package:social_media/src/controller/themeProvider.dart';
import 'package:social_media/src/screen/home_page_screen.dart';
import 'package:social_media/src/screen/register_screen.dart';
import 'package:social_media/src/widgets/widgets.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String path = "";
  late String _email, _password;
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new NetworkImage(
                  'https://images.freeimages.com/images/previews/5c6/sunset-jungle-1383333.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          child: BackdropFilter(
            filter: new ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text("Login", 30),
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(15)),
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                _email = value;
                              });
                            },
                            decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                prefixIcon:
                                    Icon(Icons.email, color: Colors.black),
                                border: OutlineInputBorder(),
                                label: Text(
                                  "Email-Address",
                                  style: TextStyle(color: Colors.black),
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(15)),
                          child: TextFormField(
                            obscureText: !Provider.of<ThemeProvider>(context,
                                    listen: false)
                                .isSecure,
                            onChanged: (value) {
                              setState(() {
                                _password = value;
                              });
                            },
                            decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                prefixIcon:
                                    Icon(Icons.lock, color: Colors.black),
                                border: OutlineInputBorder(),
                                label: Text(
                                  "Password",
                                  style: TextStyle(color: Colors.black),
                                ),
                                suffixIcon: Provider.of<ThemeProvider>(context)
                                        .isSecure
                                    ? IconButton(
                                        onPressed:
                                            (() =>
                                                Provider.of<ThemeProvider>(context,
                                                        listen: false)
                                                    .secureText()),
                                        icon: Icon(Icons.remove_red_eye,
                                            color: Colors.black))
                                    : IconButton(
                                        onPressed: (() =>
                                            Provider.of<ThemeProvider>(context,
                                                    listen: false)
                                                .secureText()),
                                        icon: Icon(Icons.visibility_off,
                                            color: Colors.black))),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        GestureDetector(
                          onTap: () async {
                            UserCredential? userCredential;
                            try {
                              userCredential = await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: _email, password: _password);
                              Provider.of<MyProvider>(context, listen: false)
                                  .currentIndex = 0;
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                print('No user found for that email.');
                              } else if (e.code == 'wrong-password') {
                                print('Wrong password provided for that user.');
                              }
                            }

                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return HomePage();
                            }));
                            // auth
                            //     .signInWithEmailAndPassword(
                            //         email: _email, password: _password)
                            //     .then((value) {

                            //   Provider.of<MyProvider>(context, listen: false)
                            //       .getUserData(value.user?.uid);

                            //   return Navigator.pushReplacement(context,
                            //       MaterialPageRoute(builder: (context) {
                            //     return HomePage();
                            //   }));
                            // }).catchError((error) {
                            //   print("error");
                            // });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Colors.yellow,
                                  Colors.orange,
                                  Colors.red,
                                ]),
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                                child: Text(
                              "Login",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )),
                            width: double.infinity,
                            height: 60,
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "don't have an account? ",
                              style: TextStyle(
                                  color: Colors.grey[100], fontSize: 20),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return Register();
                                  }));
                                },
                                child: Text("Register",
                                    style: TextStyle(
                                        color: Colors.lightBlueAccent,
                                        fontSize: 18))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
