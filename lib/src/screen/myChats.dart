import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class MyChats extends StatelessWidget {
  const MyChats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            "San Samir ",
            style: Theme.of(context).textTheme.headline6,
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: Colors.grey[300],
                  child: TextFormField(
                    onChanged: (value) {},
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                        label: Text("Search"),
                        floatingLabelBehavior: FloatingLabelBehavior.never),
                  )),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 15,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                        ),
                        title: Text("san samir"),
                        subtitle: Text("my text is here"),
                        trailing: Icon(Icons.more_horiz),
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
