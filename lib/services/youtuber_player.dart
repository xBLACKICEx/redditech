import 'package:flutter/foundation.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:flutter/material.dart';

class CustomYoutubPlayer extends StatefulWidget {
  final String? youtubeUrl;
  const CustomYoutubPlayer({ Key? key, required this.youtubeUrl }) : super(key: key);

  @override
  _CustomYoutubPlayerState createState() => _CustomYoutubPlayerState();
}

class _CustomYoutubPlayerState extends State<CustomYoutubPlayer> {
  late YoutubePlayerController? _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayerController.convertUrlToId(widget.youtubeUrl!)!,
      params: const YoutubePlayerParams(
        color: 'red',
        autoPlay: false
    ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: YoutubePlayerControllerProvider(
        controller: _controller!,
        child: YoutubePlayerIFrame(
          controller: _controller,
        )
      ),
    );
  }
}