import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hobby/core/app_colors.dart';
import 'package:hobby/core/widgets/custom_button_widget.dart';
import 'package:hobby/core/widgets/custom_text_field.dart';
import 'package:hobby/features/profile/profile_page.dart';
import 'package:lottie/lottie.dart';

class HobbyConnectPage extends StatefulWidget {
  const HobbyConnectPage({super.key});

  @override
  State<HobbyConnectPage> createState() => _HobbyConnectPageState();
}

class _HobbyConnectPageState extends State<HobbyConnectPage> {
  final TextEditingController _hobbyController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final GlobalKey<FormState> regKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.notBlack,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Form(
                key: regKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hobbies & interests',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _hobbyController,
                      hintText: 'football, guitar ...',
                      obscure: false,
                      validate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'write down your hobbies and interests';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Bio',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _bioController,
                      hintText:
                          'hello everyone my name is Vasya and i like play football',
                      obscure: false,
                      validate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'write something';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    _isLoading
                        ? Center(
                            child: Lottie.asset(
                                'assets/animations/loading_hamster.json'))
                        : CustomButtonWidget(
                            onTap: () {
                              if (regKey.currentState!.validate()) {
                                _signUp();
                              }
                            },
                            widget: const Text(
                              "Agree to Continue",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid;
      await _firestore.collection('users').doc(userId).update({
        'hobbies': _hobbyController.text.trim(),
        'bio': _bioController.text.trim(),
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('faile: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
