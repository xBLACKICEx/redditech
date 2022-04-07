import 'package:draw/draw.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:redditech/helpers/constants.dart';

class RedditAuthService {
/// This class is here to create the auth page of
/// the application, where the poeple can register
/// with Oauth2, where the use the web reddit connection.

  factory RedditAuthService() => _instance;
  static final RedditAuthService _instance = RedditAuthService._internal();
  RedditAuthService._internal();

  static final Reddit _reddit = Reddit.createInstalledFlowInstance(
    clientId: redditClientId,
    userAgent: "reddiech",
    redirectUri: Uri.parse("reddiech://authorize_callback"),
  );
  static final String _authUrl = _reddit.auth.url(['*'], 'reddiech').toString();

  Reddit get warp => _reddit;

  Future<bool> init() async {
    try {
      await _reddit.auth.refresh();
      return _reddit.auth.isValid;
    } catch (e) {
      return false;
    }
  }
/// Using try to create the connection to the Reddit account and prevent from
/// some error, like no internet connection etc.
  Future<String> login() async {
    try {
      final authCode = await FlutterWebAuth.authenticate(
          url: _authUrl, callbackUrlScheme: 'reddiech');
      String? code = Uri.parse(authCode).queryParameters["code"];

      await _reddit.auth.authorize(code.toString());

      return _reddit.auth.isValid ? "Success" : "Something is Wrong!";
    } on PlatformException {
      return 'User has cancelled or no internet!';
    } catch (e, s) {
      print('Login Uknown erorr $e, $s');
      return 'Unkown Error!';
    }
  }
}
