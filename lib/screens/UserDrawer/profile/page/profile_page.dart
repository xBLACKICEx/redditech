import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redditech/Providers/reddit_user_info_provider.dart';
import 'package:redditech/screens/UserDrawer/profile/model/user.dart';
import 'package:redditech/screens/UserDrawer/profile/page/edit_profile_page.dart';
import 'package:redditech/screens/UserDrawer/profile/utils/user_preferences.dart';
import 'package:redditech/screens/UserDrawer/profile/widget/appbar_widget.dart';
import 'package:redditech/screens/UserDrawer/profile/widget/button_widget.dart';
import 'package:redditech/screens/UserDrawer/profile/widget/numbers_widget.dart';
import 'package:redditech/screens/UserDrawer/profile/widget/profile_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = UserPreferences.getUser();
    final user2 = context.watch<RedditProvider>();

    return ThemeSwitchingArea(
      child: Builder(
        builder: (context) => Scaffold(
          appBar: buildAppBar(context),
          body: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              ProfileWidget(
                imagePath: user2.icon,
                onClicked: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const EditProfilePage()),
                  );
                  setState(() {});
                },
              ),
              const SizedBox(height: 24),
              buildName(user),
              const SizedBox(height: 24),
              const SizedBox(height: 24),
              const NumbersWidget(),
              const SizedBox(height: 48),
              if (user2.infoOf?["subreddit"]["public_description"] == null)
                const CircularProgressIndicator()
              else
                buildAbout(user2.infoOf?["subreddit"]["public_description"] as String),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildName(User user) => Column(
        children: [
          Text(
            user.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: const TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildAbout(String about) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              about,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );
}
