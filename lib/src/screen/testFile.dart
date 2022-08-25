// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:provider/provider.dart';
// import 'package:social_media/src/controller/myProvider.dart';

// class TestFile extends StatelessWidget {
//   const TestFile({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Builder(builder: (context) {
//         Provider.of<MyProvider>(context, listen: false).getFollowings();
//         return ListView.builder(
//             itemCount: Provider.of<MyProvider>(context, listen: false)
//                 .followingPosts
//                 .length,
//             itemBuilder: (context, index) {
//               print("object");
//               return FutureBuilder(
//                 builder: (context, builder) => Text(
//                     Provider.of<MyProvider>(context, listen: false)
//                         .followingPosts[index]
//                         .data()["dateTime"]),
//               );
//             });
//       }),
//     );
//   }
// }
