import 'package:monkey_chat/constants/colors.dart';
import 'package:monkey_chat/constants/images_url.dart';
import 'package:monkey_chat/services/auth/auth_service.dart';
import 'package:monkey_chat/utils/show_snackBar.dart';
import 'package:monkey_chat/widgets/button.dart';
import 'package:monkey_chat/widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  final void Function()? onTab;

  const LoginScreen({super.key, this.onTab});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // text controller
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void _signInWithEmailAndPassword() async {
    setState(() {
      _isLoading = true;
    });

    // get the auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signInWithEmailAndPassword(_emailController.text.trim(), _passwordController.text.trim());

      if (!context.mounted) return;
      showSnackBar(context, 'Login successful!', true);
    } catch (e) {
      if (!context.mounted) return;
      showSnackBar(context, e.toString(), false);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _signInWithGoogle() async {
    // get the auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signInWithGoogle();

      if (!context.mounted) return;
      showSnackBar(context, 'Login successful!', true);
    } catch (e) {
      if (!context.mounted) return;
      showSnackBar(context, e.toString(), false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              const SizedBox(height: 52),
              const Image(image: AssetImage(ImagesUrl.monkeyChat), width: 150),

              // Welcome back message
              const SizedBox(height: 24),
              const Text(
                'Welcome back you\'ve been missed!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 32),

              // Email text-field
              Input(
                  controller: _emailController,
                  hintText: 'Email',
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: AppColors.grey,
                  ),
                  obscureText: false),
              const SizedBox(height: 16),

              // Password text-field
              Input(
                  controller: _passwordController,
                  hintText: 'Password',
                  prefixIcon: const Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.grey,
                  ),
                  obscureText: true),

              // Sign in button
              const SizedBox(height: 32),
              Button(
                text: 'Sign In',
                isLoading: _isLoading,
                onTap: _isLoading ? null : _signInWithEmailAndPassword,
              ),

              // Email text-field
              const SizedBox(height: 48),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: AppColors.grey,
                  ),
                  Transform.translate(
                    offset: const Offset(160, -20),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: AppColors.white,
                      child: const Text(
                        'Or',
                        style: TextStyle(
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 44,
                        height: 44,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(9999), border: Border.all(color: AppColors.grey)),
                        child: const Image(
                          image: AssetImage(ImagesUrl.facebookIcon),
                          width: 32,
                        ),
                      )),
                  const SizedBox(
                    width: 16,
                  ),
                  GestureDetector(
                      onTap: _signInWithGoogle,
                      child: Container(
                        width: 44,
                        height: 44,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(9999), border: Border.all(color: AppColors.grey)),
                        child: const Image(
                          image: AssetImage(ImagesUrl.googleIcon),
                          width: 32,
                        ),
                      )),
                ],
              ),

              // Not a member?
              const SizedBox(
                height: 56,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Not a member?'),
                  const SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                    onTap: widget.onTab,
                    child: const Text(
                      'Register now',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
