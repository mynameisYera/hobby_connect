import 'package:flutter/material.dart';
import 'package:hobby/core/widgets/custom_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final List<Widget>? actions;
  final bool popAble;
  final VoidCallback? onPressedBack;
  const CustomAppBar({
    super.key,
    required this.title,
    required this.backgroundColor,
    this.actions,
    required this.popAble,
    this.onPressedBack,
  });
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: CustomText(
        text: title,
        size: 15,
      ),
      leading: popAble
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              color: Colors.white,
              iconSize: 16,
              onPressed: onPressedBack ??
                  () {
                    Navigator.of(context).pop();
                  },
            )
          : const SizedBox(),
      centerTitle: true,
      surfaceTintColor: backgroundColor,
      backgroundColor: backgroundColor,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
