import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hobby/core/app_colors.dart';
import 'package:hobby/core/widgets/custom_app_bar.dart';
import 'package:hobby/core/widgets/custom_bottom_navbar.dart';
import 'package:hobby/features/chat/presentation/chat_hob_page.dart';
import 'package:hobby/features/unauth/hobby_connect_page.dart';
import 'package:hobby/main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? currentUser;
  Map<String, dynamic>? userData;
  Future<void> fetchUserData(String uid) async {
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        setState(() {
          userData = userDoc.data();
        });
      } else {
        print("no data");
      }
    } catch (e) {
      print("error $e");
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        setState(() {
          currentUser = user;
        });
        await fetchUserData(user.uid);
      } else {
        setState(() {
          currentUser = null;
          userData = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String email = currentUser?.email ?? 'no email';
    String photo = currentUser?.photoURL ?? '';
    String bio = userData?['bio'] ?? 'no bio';
    String hobbies = userData?['hobbies'] ?? 'no yet';
    String username = userData?['username'] ?? 'no data';

    return Scaffold(
      backgroundColor: AppColors.notBlack,
      appBar: CustomAppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => InitializePage()));
              },
              icon: Icon(Icons.logout_rounded)),
        ],
        title: username,
        backgroundColor: Colors.transparent,
        popAble: false,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              photo.isNotEmpty
                  ? GestureDetector(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 3, color: AppColors.mainColor),
                            borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                                image: NetworkImage(photo), fit: BoxFit.cover)),
                      ),
                    )
                  : Icon(Icons.account_circle,
                      color: AppColors.mainColor, size: 100),
              Text(
                email,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HobbyConnectPage()));
                      },
                      child: Container(
                        color: Colors.red,
                        width: MediaQuery.of(context).size.width / 2,
                        child: Column(
                          children: [
                            Text(
                              'BIO:',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 5),
                              child: Text(
                                bio,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HobbyConnectPage()));
                      },
                      child: Container(
                        color: Colors.blue,
                        width: MediaQuery.of(context).size.width / 2,
                        child: Column(
                          children: [
                            Text(
                              'Hobbies:',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 5),
                              child: Text(
                                hobbies,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // SizedBox(
              //   height: 2 * 70,
              //   child: ListView.builder(
              //       physics: NeverScrollableScrollPhysics(),
              //       itemCount: 2,
              //       itemBuilder: (context, index) {
              //         return GestureDetector(
              //           onTap: () {
              //             Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                     builder: (context) => ChatHobPage()));
              //           },
              //           child: ListTile(
              //             title: Text(
              //               'hello',
              //               style: TextStyle(color: Colors.white),
              //             ),
              //             subtitle: Text('data',
              //                 style: TextStyle(color: Colors.white)),
              //           ),
              //         );
              //       }),
              // )
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavbar(page: 3),
    );
  }
}
