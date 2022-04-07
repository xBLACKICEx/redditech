import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redditech/Providers/reddit_user_info_provider.dart';
import 'package:redditech/services/info_cards.dart';


class Popular extends StatefulWidget {
  const Popular({
    Key? key,
  }) : super(key: key);

  @override
  State<Popular> createState() => _PopularState();
}

class _PopularState extends State<Popular> {
  @override
  void initState() {
    super.initState();
    context.read<RedditProvider>().getInfo("/top");
  }

  @override
  Widget build(BuildContext context) {
    final sub = context.watch<RedditProvider>().sub;
    return InfoCard(
      sub: sub,
    );
  }
}
