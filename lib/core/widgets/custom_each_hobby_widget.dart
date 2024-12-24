import 'package:flutter/material.dart';
import 'package:hobby/core/text_styles.dart';

class CustomEachHobbyWidget extends StatelessWidget {
  final String image;
  final String name;
  final int people;
  final VoidCallback onTap;
  const CustomEachHobbyWidget(
      {super.key,
      required this.image,
      required this.name,
      required this.people,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(5),
        height: 80,
        color: Colors.black87,
        width: double.infinity,
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(image: NetworkImage(image))),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              name,
              style: TextStyles.simpleText,
            ),
            Expanded(child: SizedBox()),
            Text(
              '${people}',
              style: TextStyles.headerText,
            ),
            SizedBox(
              width: 10,
            )
          ],
        ),
      ),
    );
  }
}
