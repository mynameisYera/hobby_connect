import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hobby/core/app_colors.dart';
import 'package:hobby/core/firebase_services.dart';
import 'package:hobby/core/widgets/custom_button_widget.dart';
import 'package:hobby/core/widgets/custom_text_field.dart';
import 'package:hobby/features/main/presentation/page/main_page.dart';
import 'package:hobby/features/unauth/sign_up_page.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseServices auth = FirebaseServices();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> regKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final FirebaseServices _auth = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
              ),
              Text(
                'HobbyConnect',
                style: TextStyle(
                    color: AppColors.mainColor,
                    fontSize: 50,
                    fontFamily: 'Itallian'),
              ),
              Form(
                key: regKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: const Text(
                        'Email',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: CustomTextField(
                        controller: _emailController,
                        hintText: 'Enter your email',
                        obscure: false,
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email cannot be empty';
                          }
                          final emailRegex = RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: const Text(
                        'Password',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: CustomTextField(
                        controller: _passwordController,
                        hintText: 'Enter your password',
                        obscure: true,
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password cannot be empty';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    _isLoading
                        ? Center(
                            child: Lottie.asset(
                                'assets/animations/loading_hamster.json'))
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: CustomButtonWidget(
                              onTap: () {
                                if (regKey.currentState!.validate()) {
                                  _stateLogin();
                                }
                              },
                              widget: const Text(
                                "Agree to Continue",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: CustomButtonWidget(
                  onTap: _login,
                  widget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/google.png',
                        width: 28,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text('Sign in with google')
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: CustomButtonWidget(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUpPage()));
                  },
                  widget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('Regitration')],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _stateLogin() async {
    String password = _passwordController.text;
    String email = _emailController.text;

    User? user = await _auth.signInWithEmail(email, password);

    if (user != null) {
      print('signed in');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainPage()));
    } else {
      print("failed");
    }
  }

  _login() async {
    await auth.signInWithGoogle();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MainPage()));
  }
}
