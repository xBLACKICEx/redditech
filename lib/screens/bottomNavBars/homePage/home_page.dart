import 'package:provider/provider.dart';
import 'package:redditech/Providers/reddit_user_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:redditech/screens/UserDrawer/user_drawer.dart';
import 'package:redditech/screens/bottomNavBars/bottom_nav_bar.dart';

// The Builder widget is used to have a different BuildContext to access
// closest DefaultTabController.
// final TabController tabController = DefaultTabController.of(context)!;
// tabController.addListener(() {
//   if (!tabController.indexIsChanging) {
//     // Your code goes here.
//     // To get index of current tab use tabController.index
//   }
// });
class HomePage extends StatelessWidget {
  final List<CustomTab> tabs;
  const HomePage({Key? key, required this.tabs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Builder(builder: (BuildContext context) {
        return Scaffold(
          drawer: const UserDrawer(),
          appBar: AppBar(
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.black),
                onPressed: () async {
                  showSearch(context: context, delegate: SubRedditSearch());
                },
              )
            ],
            backgroundColor: Colors.white,
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    context.read<RedditProvider>().updateUserInfo();
                    Scaffold.of(context).openDrawer();
                  },
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            ),
            bottom: TabBar(
              labelColor: Colors.black,
              indicatorColor: Colors.blue[900],
              tabs: tabs
                  .map((e) => Tab(
                        text: e.text,
                      ))
                  .toList(),
            ),
          ),
          body: TabBarView(
            children: tabs.map((e) => e.child).toList(),
          ),
        );
      }),
    );
  }
}
