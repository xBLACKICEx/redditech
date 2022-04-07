import 'package:flutter/material.dart';

import 'package:redditech/screens/login/widgets/body.dart';
import 'package:redditech/services/auth_service.dart';
import 'package:redditech/widgets/rounded_button.dart';

/// Verification and creation of the Reddit account on our application,
/// check if every thing pass correctely.
/// Using the Rounded Button to create the call to the WEB app.

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isProgressing = false;
  bool isLoggedIn = false;
  final RedditAuthService authService = RedditAuthService();

  @override
  void initState() {
    initAction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Body(
            child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (isProgressing) const CircularProgressIndicator()
        else if (!isLoggedIn)
          RoundedButton(
            text: "LOGIN WITH REDDITECH",
            iconSrc: "assets/icons/reddit.png",
            onPressed: loginAction,
          )
      ],
    )));
  }

  setLoadingState() {
    setState(() {
      isProgressing = true;
    });
  }

  setSuccessAuthState() async {
    setState(() {
      isProgressing = false;
      isLoggedIn = true;
    });
  }

  initAction() async {
    setLoadingState();
    final bool isAuth = await authService.init();
    if (isAuth) {
      setSuccessAuthState();
    } else {
      setState(() {
        isProgressing = false;
      });
    }
  }

  Future<void> loginAction() async {
    setLoadingState();
    var message = await authService.login();
    if (message == "Success") {
      setSuccessAuthState();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Success'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushNamed(context, 'main');
    } else {
      setState(() {
        isProgressing = false;
      });
    }
  }
}
