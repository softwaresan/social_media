import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:social_media/src/model/social_user_model.dart';
import 'package:social_media/src/widgets/widgets.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late String _password, _email, _name, _phone;
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
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
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          _name = value.toString();
                        });
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                          label: Text("Name")),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          _email = value.toString();
                        });
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                          label: Text("Email-Address")),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          _password = value;
                        });
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                          label: Text("Password"),
                          suffixIcon: Icon(Icons.remove_red_eye)),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          _phone = value;
                        });
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                        label: Text("Phone"),
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
                                        uid: value.user?.uid)
                                    .toMap()));
                      },
                      child: Container(
                        child: Center(
                            child: Text(
                          "Sign-Up",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )),
                        color: Color.fromRGBO(0, 10, 141, 1),
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
    );
  }
}
