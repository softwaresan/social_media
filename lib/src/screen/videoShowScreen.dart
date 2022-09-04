import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    _controller.clear();
    Provider.of<MyProvider>(context, listen: false).videos.clear();
    Provider.of<MyProvider>(context, listen: false).isVideoLiked.clear();
    Provider.of<MyProvider>(context, listen: false).videoLikesNumber.clear();

    Provider.of<MyProvider>(context, listen: false).videoUser.clear();
    Provider.of<MyProvider>(context, listen: false).descriptionVideo.clear();

    Future.delayed(Duration.zero, () async {
      await Provider.of<MyProvider>(context, listen: false).getVideos();

      Provider.of<MyProvider>(context, listen: false).videos.forEach((element) {
        _controller.add(VideoPlayerController.network(element["videoUrl"]));
      });
      for (var element in _controller) {
        element.initialize().then((value) {
          setState(() {});
        });
      }
    });
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.35,
                        ),
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              Provider.of<MyProvider>(context, listen: false)
                                  .videoUser[index]["profileImg"]),
                          radius: 27,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            print("liked");

                            Provider.of<MyProvider>(context, listen: false)
                                .likePost(
                                    Provider.of<MyProvider>(context,
                                            listen: false)
                                        .videos[index]["videoId"]
                                        .toString(),
                                    Provider.of<MyProvider>(context,
                                            listen: false)
                                        .videoUser[index]["uid"]
                                        .toString(),
                                    Provider.of<MyProvider>(context,
                                            listen: false)
                                        .isVideoLiked[index],
                                    "myVideos");
                            if (Provider.of<MyProvider>(context, listen: false)
                                .isVideoLiked[index]) {
                              Provider.of<MyProvider>(context, listen: false)
                                  .isVideoLiked[index] = false;
                              Provider.of<MyProvider>(context, listen: false)
                                  .videoLikesNumber[index]--;
                            } else {
                              Provider.of<MyProvider>(context, listen: false)
                                  .isVideoLiked[index] = true;
                              Provider.of<MyProvider>(context, listen: false)
                                  .videoLikesNumber[index]++;
                            }
                            setState(() {});
                          },
                          child: Icon(
                            Icons.favorite_rounded,
                            color:
                                Provider.of<MyProvider>(context, listen: false)
                                        .isVideoLiked[index]
                                    ? Colors.red
                                    : Colors.white,
                            size: 40,
                          ),
                        ),
                        Text(
                          Provider.of<MyProvider>(context, listen: false)
                              .videoLikesNumber[index]
                              .toString(),
                          style: TextStyle(color: Colors.white),
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
                            Provider.of<MyProvider>(context, listen: false)
                                .descriptionVideo[index],
                            style: TextStyle(color: Colors.white)))
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

    _controller.forEach((element) async {
      await element.dispose();
    });
  }
}
