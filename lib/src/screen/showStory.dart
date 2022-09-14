// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ShowStory extends StatelessWidget {
  List stories;
  ShowStory({
    Key? key,
    required this.stories,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dy > 2) {
            Navigator.pop(context);
          }
        },
        child: PageView.builder(
          itemCount: stories.length,
          itemBuilder: ((context, index) => Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(stories[index]["storyUrl"]),
                        fit: BoxFit.fill)),
              )),
        ),
      ),
    ));
  }
}
