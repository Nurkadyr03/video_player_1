import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VideoPlayerController _controller;

  List speed = [
    {
      'value': 0,
      'speed': 1,
    },
    {
      'value': 1,
      'speed': 1.0,
    },
    {
      'value': 2,
      'speed': 2.0,
    }
  ];

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/IMG_9694.MP4')
      ..initialize().then(
        (_) {
          setState(() {});
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _controller.value.isInitialized
            ? Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: () {
                            _controller.seekTo(
                              Duration(
                                  seconds:
                                      _controller.value.position.inSeconds -
                                          10),
                            );
                          },
                          color: Colors.white,
                          iconSize: 36,
                          icon: const Icon(Icons.replay_10)),
                      IconButton(
                          onPressed: () {
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          },
                          color: Colors.white,
                          iconSize: 50,
                          icon: Icon(
                            _controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                          )),
                      IconButton(
                          onPressed: () {
                            _controller.seekTo(
                              Duration(
                                  seconds:
                                      _controller.value.position.inSeconds +
                                          10),
                            );
                          },
                          color: Colors.white,
                          iconSize: 36,
                          icon: const Icon(Icons.forward_10)),
                    ],
                  ),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: Row(
                      children: [
                        PopupMenuButton(
                          icon: const Icon(
                            Icons.slow_motion_video,
                            color: Colors.white,
                            size: 26,
                          ),
                          color: const Color.fromARGB(255, 59, 56, 56),
                          itemBuilder: (context) => speed
                              .map(
                                (e) => PopupMenuItem<int>(
                                  onTap: () {
                                    setState(() {
                                      _controller.setPlaybackSpeed(e['speed']);
                                    });
                                  },
                                  value: e['value'],
                                  child: Text(
                                    e['speed'].toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            WidgetsFlutterBinding.ensureInitialized();
                            SystemChrome.setPreferredOrientations([
                              DeviceOrientation.landscapeLeft,
                              DeviceOrientation.portraitDown,
                            ]);
                          },
                          child: const Icon(
                            Icons.fullscreen,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 210.0,
                    ),
                    child: SizedBox(
                        width: double.infinity,
                        child: VideoProgressIndicator(
                          _controller,
                          allowScrubbing: true,
                          colors: const VideoProgressColors(
                            backgroundColor: Colors.white,
                            playedColor: Colors.blue,
                            bufferedColor: Color.fromARGB(255, 166, 203, 234),
                          ),
                        )),
                  ),
                ],
              )
            : Container(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
