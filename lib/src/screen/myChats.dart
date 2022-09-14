import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_media/src/controller/myProvider.dart';
import 'package:social_media/src/controller/themeProvider.dart';
import 'package:social_media/src/screen/chatScreen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyChats extends StatefulWidget {
  const MyChats({Key? key}) : super(key: key);

  @override
  State<MyChats> createState() => _MyChatsState();
}

class _MyChatsState extends State<MyChats> {
  @override
  Widget build(BuildContext context) {
    if (Provider.of<MyProvider>(context).isChat) {
      Future.delayed(Duration.zero, () async {
        await Provider.of<MyProvider>(context, listen: false)
            .getAllChatsWithFriends();
      });
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    } else {
      return SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            title: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                    Provider.of<MyProvider>(context).socialUser!.profileImg),
              ),
              title: Text(
                Provider.of<MyProvider>(context).socialUser!.name,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    color: Provider.of<ThemeProvider>(context, listen: false)
                            .isDarkMode
                        ? Colors.grey[800]
                        : Colors.grey[300],
                    child: TextFormField(
                      onChanged: (value) {
                        List tempSearch = [];
                        setState(() {
                          Provider.of<MyProvider>(context, listen: false)
                              .chats
                              .forEach((element) {
                            if (element["user"]["name"].contains(value) &&
                                value != "") {
                              tempSearch.add(element);
                              Provider.of<MyProvider>(context, listen: false)
                                  .chats = tempSearch;
                            } else if (value == "") {
                              Provider.of<MyProvider>(context, listen: false)
                                  .getAllChatsWithFriends();
                            }
                          });
                        });
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search),
                          label: Text("Search"),
                          floatingLabelBehavior: FloatingLabelBehavior.never),
                    )),
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: Provider.of<MyProvider>(context).chats.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ChatScreen(
                                friendUser: Provider.of<MyProvider>(context)
                                    .chats[index]["user"],
                                lastMsgUserIndex: index);
                          }));
                        },
                        child: Slidable(
                          endActionPane: ActionPane(
                            motion: ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  Provider.of<MyProvider>(context,
                                          listen: false)
                                      .deleteChat(Provider.of<MyProvider>(
                                              context,
                                              listen: false)
                                          .chats[index]["user"]["uid"]);
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          key: UniqueKey(),
                          child: Card(
                            elevation: 5,
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(
                                    Provider.of<MyProvider>(context)
                                        .chats[index]["user"]["profileImg"]),
                              ),
                              title: Text(Provider.of<MyProvider>(context)
                                  .chats[index]["user"]["name"]),
                              subtitle: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      Provider.of<MyProvider>(context)
                                          .chats[index]["lastMsg"],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(DateFormat.yMd()
                                      .add_jm()
                                      .format(DateTime.parse(
                                          Provider.of<MyProvider>(context)
                                              .chats[index]["lastDateTime"]))
                                      .toString()),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
      );
    }
  }
}
