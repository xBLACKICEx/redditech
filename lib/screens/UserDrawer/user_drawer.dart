import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redditech/Providers/reddit_user_info_provider.dart';
import 'package:redditech/services/auth_service.dart';
import '/page/favourites_page.dart';
import '/page/people_page.dart';
import '/page/user_page.dart';
import 'profile/page/profile_page.dart';


class UserDrawer extends StatelessWidget {
  // final padding = const EdgeInsets.symmetric(horizontal: 10);
  /// This is where we create the User Drawer like the real Reddit,
  /// with all the different caracteristic that you can found, like the 
  /// profile, the information of the account, the settings etc...

  const UserDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<RedditProvider>();
    const email = 'Jeremy@epitech.eu';

    return Drawer(
      child: Material(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            buildHeader(
              urlImage: user.icon,
              name: user.infoOf?["subreddit"]["display_name_prefixed"] ?? "loading",
              email: email,
              onClicked: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UserPage(
                  name: "Avatar",
                  urlImage: user.icon,
                ),
              )),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Text(
                   user.infoOf?["subreddit"]["display_name_prefixed"] ?? "loading",
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  const Divider(color: Colors.black),
                  buildMenuItem(
                    text: 'My profile',
                    icon: Icons.account_circle_outlined,
                    onClicked: () => selectedItem(context, 0),
                  ),
                  buildMenuItem(
                    text: 'Create a community',
                    icon: Icons.radar,
                    onClicked: () => selectedItem(context, 1),
                  ),
                  buildMenuItem(
                    text: 'Reddit Coins',
                    icon: Icons.money_off,
                    onClicked: () => selectedItem(context, 2),
                  ),
                  buildMenuItem(
                    text: 'Reddit Premium',
                    icon: Icons.attach_money_outlined,
                    onClicked: () => selectedItem(context, 3),
                  ),
                  buildMenuItem(
                    text: 'Saved',
                    icon: Icons.save,
                    onClicked: () => selectedItem(context, 4),
                  ),
                  buildMenuItem(
                    text: 'History',
                    icon: Icons.history,
                    onClicked: () => selectedItem(context, 4),
                  ),
                  buildMenuItem(
                    text: 'Pending Posts',
                    icon: Icons.picture_in_picture_rounded,
                    onClicked: () => selectedItem(context, 5),
                  ),
                  buildMenuItem(
                    text: 'Drafts',
                    icon: Icons.article_outlined,
                    onClicked: () => selectedItem(context, 6),
                  ),
                  const SizedBox(height: 30),
                  buildMenuItem(
                    text: 'Settings',
                    icon: Icons.settings,
                    onClicked: () => selectedItem(context, 7),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader({
    required String urlImage,
    required String name,
    required String email,
    required VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
          child: Row(
            children: [
              CircleAvatar(radius: 80, backgroundImage: NetworkImage(urlImage)),
              // const SizedBox(width: 20),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              // children: [
              //   Text(
              //     name,
              //     style: const TextStyle(fontSize: 20, color: Colors.black),
              //   ),
              //   const SizedBox(height: 4),
              //   Text(
              //     email,
              //     style: const TextStyle(fontSize: 14, color: Colors.black),
              //   ),
              // ],
              // ),
              // const Spacer(),
              // const CircleAvatar(
              //   radius: 24,
              //   backgroundColor: Colors.black,
              //   child: Icon(Icons.add_comment_outlined, color: Colors.grey),
              // )
            ],
          ),
        ),
      );

  Widget buildSearchField() {
    const color = Colors.black;

    return TextField(
      style: const TextStyle(color: color),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        hintText: 'Search',
        hintStyle: const TextStyle(color: color),
        prefixIcon: const Icon(Icons.search, color: color),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    const color = Colors.black;
    const hoverColor = Colors.black;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: const TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const ProfilePage(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const FavouritesPage(),
        ));
        break;
    }
  }
}
