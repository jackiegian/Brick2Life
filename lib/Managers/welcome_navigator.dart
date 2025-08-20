import 'package:flutter/material.dart';
import '../Screens/login_signup/login_screen.dart';
import '../Screens/login_signup/signup_screen.dart';

class AuthPageView extends StatefulWidget {
  final int initialPage;

  AuthPageView({this.initialPage = 0});

  @override
  _AuthPageViewState createState() => _AuthPageViewState();
}

class _AuthPageViewState extends State<AuthPageView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialPage);
  }

  void _navigateToSignUp() {
    Future.delayed(Duration(milliseconds: 300), ()
    {
      _pageController.jumpToPage(
        1,
      );
    });
  }

  void _navigateToLogin() {
    Future.delayed(Duration(milliseconds: 300), ()
    {
      _pageController.jumpToPage(
        0,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            children: [
              LoginScreen(onSignUp: _navigateToSignUp),
              SignUpScreen(onLogin: _navigateToLogin),
            ],
          ),
        ),
      ],
    );
  }
}
