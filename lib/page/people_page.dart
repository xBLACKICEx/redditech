import 'package:flutter/material.dart';

class PeoplePage extends StatelessWidget {
  /// Sets the tooltip to [Key], creating the front page during the UserPage.
  const PeoplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        //drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          title: const Text('People'),
          centerTitle: true,
          backgroundColor: Colors.grey,
        ),
      );
}
