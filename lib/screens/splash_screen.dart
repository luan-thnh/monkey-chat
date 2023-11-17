import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:monkey_chat/constants/images_url.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  final Widget? nextScreen;
  final int? duration;
  const SplashScreen({super.key, this.nextScreen, this.duration = 2000});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: ImagesUrl.monkeyChat,
      splashIconSize: 300,
      nextScreen: nextScreen!,
      splashTransition: SplashTransition.fadeTransition,
      duration: duration!,
    );
  }
}
