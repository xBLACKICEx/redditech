import 'package:draw/draw.dart';
import 'package:flutter/cupertino.dart';
import 'package:redditech/services/auth_service.dart';

  /// Find all the information of the Reddit user to fill our application.
  /// Fill the Profile page with the 3 profile infos. 
class RedditProvider with ChangeNotifier {
  final _reddit = RedditAuthService().warp;

  Redditor? _user;
  Map<String, dynamic>? _netInfo;
  List<Submission?>? _sub;

  Map<dynamic, dynamic>? get infoOf => _user?.data;

  Redditor? get user => _user;

  Map<String, dynamic>? get netInfo => _netInfo;

  int get createDays {
    return DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(
            (infoOf!["created_utc"]).round() * 1000,
            isUtc: true))
        .inDays;
  }

  String get icon {
    if (infoOf!["snoovatar_img"] == "") {
      return infoOf!["icon_img"];
    } else {
      return infoOf!["snoovatar_img"];
    }
  }

  List<Submission?>? get sub => _sub;

  Future<void> updateUserInfo() async {
    _user = await _reddit.user.me();
    notifyListeners();
  }

  getSubredditInfo(List<Submission?>? tmpSub) async {
    var s = tmpSub!.map((e) async => await e!.subreddit.fetch()).toList();
  }

  Future<void> getInfo(String category) async {
    try {
      _netInfo = await _reddit.get(category);
      _sub = (_netInfo!["listing"] as List<dynamic>).map((e) {
        if (e is Submission) {
          return e;
        }
      }).toList();
    } catch (e) {
      _sub = null;
    }
    notifyListeners();
  }

  void suredditsear() async {
    final s = await _reddit.subreddits.searchByName("flutter");
    print("result:................ }");
    notifyListeners();
  }
}
