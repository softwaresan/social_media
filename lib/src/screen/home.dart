import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 20,
              child: Image.network(
                "https://img.freepik.com/free-vector/young-people-standing-talking-each-other-speech-bubble-smartphone-girl-flat-vector-illustration-communication-discussion_74855-8741.jpg",
                fit: BoxFit.fill,
              ),
            ),
            Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 20,
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 5),
                    title: Text("San Samir Boya"),
                    subtitle: Text("11/11/2022"),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://media-cldnry.s-nbcnews.com/image/upload/t_nbcnews-fp-1024-512,f_auto,q_auto:best/newscms/2021_07/2233721/171120-smile-stock-njs-333p.jpg"),
                      radius: 24,
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.more_horiz),
                      onPressed: () {},
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                        style: Theme.of(context).textTheme.subtitle1),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 300,
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image.network(
                        "https://media-cldnry.s-nbcnews.com/image/upload/t_nbcnews-fp-1024-512,f_auto,q_auto:best/newscms/2021_07/2233721/171120-smile-stock-njs-333p.jpg",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                        Icon(Icons.favorite_outline),
                        Text("120"),
                        Spacer(),
                        Icon(Icons.add_comment_outlined),
                        Text("100")
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR2s-iBfRB7h11Ab-20_HKNBNfmsisGN5ursw&usqp=CAU"),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Write comments ..."),
                        Spacer(),
                        Icon(Icons.favorite_outline),
                        Text("Like"),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
