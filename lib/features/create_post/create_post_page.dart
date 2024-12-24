import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hobby/core/app_colors.dart';
import 'package:hobby/core/widgets/custom_app_bar.dart';
import 'package:hobby/core/widgets/custom_button_widget.dart';
import 'package:hobby/core/widgets/custom_text_field.dart';
import 'package:hobby/features/every_page/presentation/every_page.dart';
import 'package:lottie/lottie.dart';

class CreatePostPage extends StatefulWidget {
  final String collections;
  const CreatePostPage({super.key, required this.collections});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final GlobalKey<FormState> regKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: 'Create Post',
          backgroundColor: Colors.transparent,
          popAble: true),
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
                      'Description',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _titleController,
                      hintText: 'description',
                      obscure: false,
                      validate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'write something';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'URL photo',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _imageController,
                      hintText: 'put image url',
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
                                _publish(widget.collections);
                              }
                            },
                            widget: const Text(
                              "Publish",
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

  Future<void> _publish(String collection) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;

      final userDoc = await _firestore.collection('users').doc(user!.uid).get();

      final username = userDoc.data()?['username'] ?? 'Anonymous';

      final newPost = {
        'title': _titleController.text.trim(),
        'image': _imageController.text.trim(),
        'username': username,
      };

      await _firestore.collection('hobbies').doc(collection).set(
        {
          'post': FieldValue.arrayUnion([newPost]),
        },
        SetOptions(merge: true),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => EveryPage(
                  collections: collection,
                )),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('failed: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
