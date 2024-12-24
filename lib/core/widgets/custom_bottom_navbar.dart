import 'package:flutter/material.dart';
import 'package:hobby/core/app_colors.dart';
import 'package:hobby/features/chat/presentation/open_chat_page.dart';
import 'package:hobby/features/main/presentation/page/main_page.dart';
import 'package:hobby/features/profile/profile_page.dart';

class CustomBottomNavbar extends StatelessWidget {
  final int page;
  const CustomBottomNavbar({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70,
      color: AppColors.mainColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainPage()),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.list,
                  color: page == 1 ? Colors.white : Colors.amber,
                ),
                Text(
                  'Hobbies',
                  style:
                      TextStyle(color: page == 1 ? Colors.white : Colors.amber),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ChatPage()),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat,
                    color: page == 2 ? Colors.white : Colors.amber),
                Text(
                  'Chat',
                  style:
                      TextStyle(color: page == 2 ? Colors.white : Colors.amber),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person,
                  color: page == 3 ? Colors.white : Colors.amber,
                ),
                Text(
                  'Profile',
                  style:
                      TextStyle(color: page == 3 ? Colors.white : Colors.amber),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
