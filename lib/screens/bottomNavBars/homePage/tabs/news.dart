import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redditech/Providers/reddit_user_info_provider.dart';
import 'package:redditech/services/info_cards.dart';

class News extends StatefulWidget {
  const News({Key? key,}) : super(key: key);

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  @override
  void initState() {
    super.initState();
    context.read<RedditProvider>().getInfo("/new");
  }

  @override
  Widget build(BuildContext context) {
    final sub = context.watch<RedditProvider>().sub;
    return InfoCard(
      sub: sub,
    );
  }
}