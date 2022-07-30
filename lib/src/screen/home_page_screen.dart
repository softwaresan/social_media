import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:social_media/src/controller/myProvider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text("Home", style: Theme.of(context).textTheme.subtitle1),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.chat_outlined,
                    color: Colors.black,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.add_a_photo_outlined,
                    color: Colors.black,
                  ))
            ],
          ),
          body: Provider.of<MyProvider>(context)
              .screens[Provider.of<MyProvider>(context).currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: Provider.of<MyProvider>(context).currentIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              Provider.of<MyProvider>(context, listen: false)
                  .changeScreen(index);
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), label: "Search"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: "Profile"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: "settings")
            ],
          )),
    );
  }
}
