import 'package:draw/draw.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redditech/services/youtuber_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Creation of the card, the publish of the differents
/// subreddit that you follow, with all the information
/// of the publication.

class InfoCard extends StatefulWidget {
  final List<Submission?>? sub;

  const InfoCard({Key? key, required this.sub}) : super(key: key);

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  /// Desingnin the card to fit and accept all the diffrents detail that
  /// reddit post have. With the Title, the name of the one who post, the
  /// description, the picture etc ...
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100]!,
      child: widget.sub == null || widget.sub!.isEmpty
          ? Container(
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.only(top: 20),
              child: Center(
                child: CircularProgressIndicator(
                  value: 0.8,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red[300]!),
                ),
              ))
          : Container(
              color: Colors.grey[100]!,
              child: ListView.builder(
                itemCount: widget.sub!.length,
                itemBuilder: (context, index) {
                  return _submssionInfo(widget.sub![index]!);
                },
              ),
            ),
    );
  }

  String subCreated(DateTime date) {
    final created = DateTime.now().difference(date);
    if (created.inHours < 1) {
      return created.inMinutes.toString() + "m";
    } else if (created.inHours > 24) {
      return created.inDays.toString() + "d";
    }
    return created.inHours.toString() + "h";
  }

  /// Fill the card with all the information recive with the [submission?.author]
  /// and subCreated function that we have already create.

  Widget _filterUrl(String? url) {
    if (url == null) {
      return Container();
    }

    final imgUrl = RegExp(
        r"^https?://(?:[a-z0-9\-]+\.)+[a-z]{2,6}(?:/[^/#?]+)+\.(?:jpg|gif|png)$");

    if (url.startsWith("https://www.youtube.com/watch") ||
        url.startsWith("https://youtu.be/")) {
      return CustomYoutubPlayer(youtubeUrl: url);
    } else if (imgUrl.hasMatch(url)) {
      return Image.network(url);
    }
    return Container();
  }

  Card _submssionInfo(Submission submission) {
    if (widget.sub == null) {
      return const Card();
    } else {
      return Card(
        color: Colors.white,
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              leading: const Image(
                image: NetworkImage(
                    'https://b.thumbs.redditmedia.com/E6-lBIXAELKdtcb4HaXUEuSSIKrsF9tOUgjnb5UYFrU.png'),
              ),
              title: Text(
                "${submission.data?["subreddit_name_prefixed"]}",
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
              subtitle: Text(
                  "Posted by u/${submission.author}·${subCreated(submission.createdUtc)}",
                  style: const TextStyle(
                    fontSize: 15,
                  )),
            ),
            // Divider(),
            ListTile(
              title: Text(
                submission.title,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              subtitle: Text(submission.subject ?? ""),
            ),
            _filterUrl(submission.data!["url_overridden_by_dest"])
          ],
        ),
      );
    }
  }
}
