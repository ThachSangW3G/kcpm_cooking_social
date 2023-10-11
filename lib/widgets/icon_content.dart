
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/app_styles.dart';

class IconContent extends StatelessWidget {
  final String label;
  final String iconData;
  final VoidCallback onTap;
  const IconContent(
      {super.key,
        required this.label,
        required this.iconData,
        required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          SvgPicture.asset(
            iconData,
            height: 25,
            width: 25,
            // colorFilter: const ColorFilter.mode(
            //   Colors.black,
            //   BlendMode.srcIn
            // ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(label, style: kLabelTextStyle)
        ],
      ),
    );
  }
}
