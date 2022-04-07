import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:redditech/screens/login/widgets/background.dart';

class Body extends StatelessWidget {
  final Widget child;

  const Body({Key? key, required this.child}) : super(key: key);
/// This class is here to create the body of
/// the application
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    /// This size provide us total height and width of our screen
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "WELCOME TO REDDITECH",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.05),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.45,
            ),
            SizedBox(height: size.height * 0.05),
            child,
          ],
        ),
      ),
    );
  }
}
