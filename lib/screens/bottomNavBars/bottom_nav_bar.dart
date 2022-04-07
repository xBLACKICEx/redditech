import 'package:draw/draw.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:redditech/Providers/reddit_user_info_provider.dart';
import 'package:redditech/screens/bottomNavBars/homePage/home_page.dart';
import 'package:redditech/screens/bottomNavBars/homePage/tabs/news.dart';
import 'package:redditech/services/auth_service.dart';
import 'package:redditech/services/info_cards.dart';
import 'bottom_imports.dart';

/// Creation of the button Nav bar with all the different part of it,
/// like the real reddit.
/// Home button, Navigation where you will be able to research things etc ...
class CustomTab {
  final String text;
  final Widget child;
  CustomTab(this.text, this.child);
}

enum SubredditSubmssionType {
  hot,
  news,
  top,
}

class BottomNavBarPage extends StatefulWidget {
  const BottomNavBarPage({Key? key}) : super(key: key);

  @override
  _BottomNavBarPageState createState() => _BottomNavBarPageState();
}

class _BottomNavBarPageState extends State<BottomNavBarPage> {
  /// Creation of all the different categorie that we will be able to fill
  /// if we want to finish our application totaly.
  final bottomNavBarItem = const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
        icon: Icon(Icons.home, size: 40, color: Colors.black),
        label: 'Home',
        backgroundColor: Colors.white),
    BottomNavigationBarItem(
        icon: Icon(Icons.assistant_navigation, size: 30, color: Colors.black),
        label: 'Navigation',
        backgroundColor: Colors.white),
    BottomNavigationBarItem(
        icon: Icon(Icons.add_sharp, size: 40, color: Colors.black),
        label: 'Posts',
        backgroundColor: Colors.white),
    BottomNavigationBarItem(
        icon: Icon(Icons.chat_bubble_outline_rounded,
            size: 25, color: Colors.black),
        label: 'Messages',
        backgroundColor: Colors.white),
    BottomNavigationBarItem(
        icon: Icon(Icons.add_alert_outlined, size: 30, color: Colors.black),
        label: 'Inbox',
        backgroundColor: Colors.white),
  ];

  int currentIndex = 0;

  /// Create the different part of the post with the Best, Top, New, Hot that
  /// we will fill with all the information of the reddit post that we can find.
  final pages = <Widget>[
    HomePage(tabs: [
      CustomTab('Best', const Awarded()),
      CustomTab('Hot', const Home()),
      CustomTab('New', const News()),
      CustomTab('top', const Popular()),
    ]),
    const NavigationPage(),
    const NewPostPage(),
    const MessagesPage(),
    AlertsPage(tabs: [
      CustomTab('Activity', const Notifications()),
      CustomTab('Messages', const Messages())
    ]),
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    context.read<RedditProvider>().updateUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavBarItem,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.shifting,
        onTap: (index) {
          _changePage(index);
        },
      ),
      body: pages[currentIndex],
    );
  }

  _changePage(int index) {
    if (index != currentIndex) {
      setState(() {
        currentIndex = index;
      });
    }
  }
}

class SubRedditSearch extends SearchDelegate<String> {
  final _reddit = RedditAuthService().warp;
  SubredditRef? subredditRef;
  final types = {
    SubredditSubmssionType.hot: "hot",
    SubredditSubmssionType.news: "news",
    SubredditSubmssionType.top: "top"
  };
  SubredditSubmssionType type = SubredditSubmssionType.hot;

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, "");
            } else {
              query = '';
              showSuggestions(context);
            }
          },
        )
      ];

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ""),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<Subreddit>(
      future: subredditRef!.populate(),
      builder: (context, snapshot) {
        if (query.isEmpty) return buildNoSuggestions();
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError || snapshot.data == null) {
              return Container();
            } else {
              final subInfoOf = snapshot.data!.data!;
              final subreddit = snapshot.data!;
              return Card(
                // margin: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    Stack(children: [
                      ListTile(
                        leading: snapshot.data!.iconImage.toString().isEmpty
                            ? SvgPicture.asset(
                                "assets/icons/no_costom_img.svg",
                                color: Colors.blue,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                  snapshot.data!.iconImage.toString(),
                                ),
                              ),
                        title: Text(snapshot.data!.displayName,
                            style: const TextStyle(fontSize: 28)),
                        subtitle: Column(
                          children: [
                            Text(subInfoOf["subscribers"].toString() +
                                " membres·" +
                                subInfoOf["accounts_active"].toString() +
                                " online"),
                            Text(subInfoOf["public_description"] ??
                                "No description for Subreddit!!"),
                          ],
                        ),
                      ),
                    ]),
                    const Divider(),
                    FutureBuilder<List<Submission>>(
                      future: getSubredditSubmmtion(subreddit),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Center(
                                child: CircularProgressIndicator());
                          default:
                            if (snapshot.hasError || snapshot.data == null) {
                              return Container();
                            } else {
                              return Expanded(
                                  child: InfoCard(sub: snapshot.data));
                            }
                        }
                      },
                    )
                  ],
                ),
                // color: Colors.purpleAccent[100],
                elevation: 20, // 阴影⾼度
              );
            }
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<SubredditRef>>(
      future: _reddit.subreddits.searchByName(query),
      builder: (context, snapshot) {
        if (query.isEmpty) return buildNoSuggestions();
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError || snapshot.data == null) {
              return buildNoSuggestions();
            } else {
              return buildSuggestionsSuccess(snapshot.data!);
            }
        }
      },
    );
  }

  Widget buildSuggestionsSuccess(List<SubredditRef> suggestions) =>
      ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final suggestion = suggestions[index];
            final queryText = suggestion.displayName.substring(0, query.length);
            final remainingText =
                suggestion.displayName.substring(query.length);
            return ListTile(
              onTap: () {
                query = suggestion.displayName;
                subredditRef = suggestions[index];
                showResults(context);
              },
              title: RichText(
                text: TextSpan(
                  text: queryText,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  children: [
                    TextSpan(
                      text: remainingText,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });

  Widget buildNoSuggestions() => const Center(
        child: Text(
          'No suggestions!',
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
      );

  Future<List<Subreddit>> searchSubreddit(String query) async {
    final subredditRefs = await _reddit.subreddits.searchByName(query);
    final subreddits = <Subreddit>[];
    for (var e in subredditRefs) {
      subreddits.add(await e.populate());
    }
    return subreddits;
  }

  Future<List<Submission>> getSubredditSubmmtion(Subreddit subreddit,
      {SubredditSubmssionType type = SubredditSubmssionType.hot}) async {
    Stream<UserContent> stream;
    switch (type) {
      case SubredditSubmssionType.news:
        stream = subreddit.newest();
        break;
      case SubredditSubmssionType.top:
        stream = subreddit.top();
        break;
      default:
        stream = subreddit.hot();
    }
    List<Submission> submission = [];
    await for (final value in stream) {
      submission.add(value as Submission);
    }
    return submission;
  }
}