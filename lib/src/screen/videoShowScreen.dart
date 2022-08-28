import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media/src/controller/myProvider.dart';
import 'package:video_player/video_player.dart';

/// Stateful widget to fetch and then display video content.
class Videos extends StatefulWidget {
  const Videos({Key? key}) : super(key: key);

  @override
  _VideosState createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  List<VideoPlayerController> _controller = [];

  @override
  void initState() {
    super.initState();
    Provider.of<MyProvider>(context, listen: false)
        .videoController
        .forEach((element) {
      _controller.add(VideoPlayerController.network(element));
    });
    for (var element in _controller) {
      element
        ..initialize().then((value) {
          setState(() {});
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: PageView.builder(
      scrollDirection: Axis.vertical,
      clipBehavior: Clip.none,
      onPageChanged: (index) async {},
      itemCount: _controller.length,
      itemBuilder: (context, index) {
        _controller[index].setLooping(true);
        _controller[index].play();
        return Stack(
          children: [
            VideoPlayer(_controller[index]),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.35,
                        ),
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              Provider.of<MyProvider>(context, listen: false)
                                  .socialUser!
                                  .profileImg),
                          radius: 27,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Icon(
                          Icons.favorite_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Icon(
                          Icons.mode_comment_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Icon(
                          Icons.ios_share,
                          color: Colors.white,
                          size: 40,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                            "dshjhfjsdhfkjsdhfkjshdkfjhskjdfhksjdhfkjshdkfjh"))
                  ],
                ),
              ),
            )
          ],
        );
      },
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.forEach((element) {
      element.dispose();
    });
  }
}
