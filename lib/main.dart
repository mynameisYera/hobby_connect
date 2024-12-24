import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hobby/core/app_colors.dart';
import 'package:hobby/features/main/presentation/page/main_page.dart';
import 'package:hobby/features/main/presentation/bloc/message_bloc/post_bloc.dart';
import 'package:hobby/features/unauth/login_page.dart';
import 'package:hobby/firebase_options.dart';
import 'package:lottie/lottie.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());

  GetIt.instance.registerLazySingleton<PostBloc>(() => PostBloc());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: const InitializePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class InitializePage extends StatelessWidget {
  const InitializePage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      });
    });

    return Scaffold(
      body:
          Center(child: Lottie.asset('assets/animations/loading_hamster.json')),
    );
  }
}
