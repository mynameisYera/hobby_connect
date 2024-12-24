import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hobby/core/app_colors.dart';
import 'package:hobby/core/widgets/custom_app_bar.dart';
import 'package:hobby/core/widgets/custom_bottom_navbar.dart';
import 'package:hobby/core/widgets/custom_each_hobby_widget.dart';
import 'package:hobby/features/every_page/presentation/every_page.dart';
import 'package:hobby/features/profile/profile_page.dart';
import 'package:lottie/lottie.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  User? currentUser;
  Future<List<Map<String, dynamic>>> _getHobbies() async {
    try {
      final hobbiesRef = FirebaseFirestore.instance.collection('hobbies');
      final snapshot = await hobbiesRef.get();
      return snapshot.docs.map((doc) {
        return {
          'name': doc.id,
          'image': doc['image'] ??
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYFhNLjRKHgrAPc6QcPbyLKcqHWmrMS6ZOqg&s',
          'people': doc['people'] ?? 0,
        };
      }).toList();
    } catch (e) {
      print('Error fetching hobbies: $e');
      return [];
    }
  }

  late Future<List<Map<String, dynamic>>> _hobbiesFuture;

  @override
  void initState() {
    super.initState();

    // Fetch hobbies when the page initializes
    _hobbiesFuture = _getHobbies();

    // Listen for authentication state changes
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        currentUser = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String photo = currentUser?.photoURL ?? '';

    return Scaffold(
      appBar: CustomAppBar(
        popAble: false,
        backgroundColor: AppColors.notBlack,
        title: 'Hobbies',
        actions: [
          CircleAvatar(
            child: photo.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border:
                            Border.all(width: 3, color: AppColors.mainColor),
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                          image: NetworkImage(photo),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    },
                    child: Icon(Icons.account_circle, size: 40),
                  ),
          ),
          SizedBox(width: 10),
        ],
      ),
      backgroundColor: AppColors.notBlack,
      bottomNavigationBar: CustomBottomNavbar(page: 1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _hobbiesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: Lottie.asset(
                            'assets/animations/loading_hamster.json'));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No hobbies'));
                  } else {
                    final hobbies = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: hobbies.length,
                      itemBuilder: (context, index) => Column(
                        children: [
                          CustomEachHobbyWidget(
                            image: hobbies[index]['image'],
                            name: hobbies[index]['name'],
                            people: hobbies[index]['people'],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EveryPage(
                                    collections: hobbies[index]['name'],
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
