import 'package:monkey_chat/screens/login_screen.dart';
import 'package:monkey_chat/screens/register_screen.dart';
import 'package:flutter/material.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  // initially show the login screen
  bool showLoginScreen = true;

  // toggle between login and register screen
  void toggleScreens() {
    setState(() {
      showLoginScreen = !showLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showLoginScreen ? LoginScreen(onTab: toggleScreens) : RegisterScreen(onTab: toggleScreens);
  }
}
