import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redditech/Providers/reddit_user_info_provider.dart';
import 'package:redditech/services/info_cards.dart';

class Awarded extends StatefulWidget {
  const Awarded({Key? key,}) : super(key: key);

  @override
  State<Awarded> createState() => _AwardedState();
}

class _AwardedState extends State<Awarded> {
   @override
  void initState() {
    super.initState();
    context.read<RedditProvider>().getInfo("/best");
  }

  @override
  Widget build(BuildContext context) {
    final sub = context.watch<RedditProvider>().sub;
    return InfoCard(
      sub: sub,
    );
  }
}