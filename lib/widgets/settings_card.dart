import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letter_round/ressources/colors.dart';

class SettingsCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPress;

  const SettingsCard({
    required this.title,
    required this.icon,
    required this.onPress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Container(
          color: blackColor,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: backgroundColor,
                child: Icon(icon, color: greyColor),
              ),
              SizedBox(width: 16),
              Text(title, style: TextStyle(color: whiteColor, fontSize: 17)),
              Spacer(),
              Icon(CupertinoIcons.right_chevron, color: whiteColor, size: 26,),
            ],
          ),
        ),
      ),
    );
  }
}
