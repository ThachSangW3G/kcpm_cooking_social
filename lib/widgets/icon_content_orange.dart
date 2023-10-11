import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

class IconContentOrange extends StatelessWidget {
  final String label;
  final String iconData;
  const IconContentOrange(
      {super.key, required this.label, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          iconData,
          height: 20,
          width: 20,
          colorFilter:
          const ColorFilter.mode(AppColors.orangeCrusta, BlendMode.srcIn),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(label, style: kReviewLabelTextStyle)
      ],
    );
  }
}
