import 'package:monkey_chat/constants/colors.dart';
import 'package:monkey_chat/constants/images_url.dart';
import 'package:monkey_chat/services/auth/auth_service.dart';
import 'package:monkey_chat/utils/show_snackBar.dart';
import 'package:monkey_chat/widgets/button.dart';
import 'package:monkey_chat/widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  final void Function()? onTab;

  const RegisterScreen({super.key, this.onTab});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // text controller
  bool _isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  void _signUpWithEmailAndPassword() async {
    if (passwordController.text != confirmPasswordController.text) {
      showSnackBar(context, 'Passwords do not match!', false);

      return;
    }

    setState(() {
      _isLoading = true;
    });

    // get the auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signUpWithEmailAndPassword(context, emailController.text.trim(), passwordController.text.trim());

      if (!context.mounted) return;
      showSnackBar(context, 'Register successful!', true);
    } catch (e) {
      if (!context.mounted) return;
      showSnackBar(context, e.toString(), false);
    } finally {
      setState(() {
        _isLoading = false;
      });
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

              // Create account message
              const SizedBox(height: 24),
              const Text(
                'Let\'s create an account for you!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),

              // Email text-field
              const SizedBox(height: 32),
              Input(
                  controller: emailController,
                  hintText: 'Email',
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: AppColors.grey,
                  ),
                  obscureText: false),

              // Password text-field
              const SizedBox(height: 16),
              Input(
                  controller: passwordController,
                  hintText: 'Password',
                  prefixIcon: const Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.grey,
                  ),
                  obscureText: true),

              // Confirm password text-field
              const SizedBox(height: 16),
              Input(
                  controller: confirmPasswordController,
                  hintText: 'Confirm password',
                  prefixIcon: const Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.grey,
                  ),
                  obscureText: true),

              // Sign up button
              const SizedBox(height: 32),
              Button(
                text: 'Sign Up',
                isLoading: _isLoading,
                onTap: _isLoading ? null : _signUpWithEmailAndPassword,
              ),

              // Login by google or facebook
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
                      onTap: () {},
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
              const SizedBox(height: 56),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already a member?'),
                  const SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                    onTap: widget.onTab,
                    child: const Text(
                      'Login now',
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
