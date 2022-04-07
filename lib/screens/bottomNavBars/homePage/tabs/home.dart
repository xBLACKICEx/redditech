import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redditech/Providers/reddit_user_info_provider.dart';
import 'package:redditech/services/info_cards.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    context.read<RedditProvider>().getInfo("/hot");
  }

  @override
  Widget build(BuildContext context) {
    final sub = context.watch<RedditProvider>().sub;
    return InfoCard(
      sub: sub,
    );
  }
}

