
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/app_colors.dart';

class RowContent extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const RowContent({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          const SizedBox(
            height: 23,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 17,
                  fontFamily: "CeraPro",
                  // color: Colors.black
                ),
              ),
              SvgPicture.asset(
                'assets/icon_svg/chevron-circle-right.svg',
                height: 19,
                width: 11,
                colorFilter: const ColorFilter.mode(
                    AppColors.greyBombay, BlendMode.srcIn),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
