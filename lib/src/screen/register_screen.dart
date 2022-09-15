import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:social_media/src/model/social_user_model.dart';
import 'package:social_media/src/screen/sign_in_screen.dart';
import 'package:social_media/src/widgets/widgets.dart';

import '../controller/themeProvider.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late String _password, _email, _name, _phone;
  String _profileImg =
      "https://cdt.org/wp-content/uploads/2015/10/2015-10-06-FB-person_sq.png";
  String _coverImg =
      "https://cdt.org/wp-content/uploads/2015/10/2015-10-06-FB-person_sq.png";
  String _bio = "this is my bio";

  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "https://i.pinimg.com/originals/0b/1f/36/0b1f36f76ca63a6174fbfdc9f912ebe5.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text("Register", 30),
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
                                _name = value.toString();
                              });
                            },
                            decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                prefixIcon:
                                    Icon(Icons.person, color: Colors.black),
                                border: OutlineInputBorder(),
                                label: Text(
                                  "Name",
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
                            onChanged: (value) {
                              setState(() {
                                _email = value.toString();
                              });
                            },
                            decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                prefixIcon:
                                    Icon(Icons.email, color: Colors.black),
                                border: OutlineInputBorder(),
                                label: Text("Email-Address",
                                    style: TextStyle(color: Colors.black))),
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
                                label: Text("Password",
                                    style: TextStyle(color: Colors.black)),
                                suffixIcon: Provider.of<ThemeProvider>(context).isSecure
                                    ? IconButton(
                                        onPressed: (() =>
                                            Provider.of<ThemeProvider>(context, listen: false)
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
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(15)),
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                _phone = value;
                              });
                            },
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              prefixIcon: Icon(
                                Icons.phone,
                                color: Colors.black,
                              ),
                              border: OutlineInputBorder(),
                              label: Text("Phone",
                                  style: TextStyle(color: Colors.black)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        GestureDetector(
                          onTap: () {
                            auth
                                .createUserWithEmailAndPassword(
                                    email: _email, password: _password)
                                .then((value) => FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(value.user?.uid)
                                    .set(SocialUser(
                                            name: _name,
                                            email: _email,
                                            phone: _phone,
                                            uid: value.user?.uid,
                                            profileImg: _profileImg,
                                            coverImg: _coverImg,
                                            bio: _bio)
                                        .toMap()))
                                .then((value) => Navigator.pop(context));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: LinearGradient(colors: [
                                  Colors.yellow,
                                  Colors.orange,
                                  Colors.red
                                ])),
                            child: Center(
                                child: Text(
                              "Sign-Up",
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
