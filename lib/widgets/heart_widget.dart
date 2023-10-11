import 'package:flutter/cupertino.dart';

import '../constants/app_colors.dart';

class HeartWidget extends StatelessWidget {


  final VoidCallback like;
  final bool liked;

  const HeartWidget({super.key, required this.like, required this.liked});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: like,
      child: Container(
        height: 50,
        width: 50,
        decoration: const BoxDecoration(
           color: AppColors.white,
           shape: BoxShape.circle),
        child: Center(
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: liked  ? const AssetImage('assets/icons/heart_orange.png') : const AssetImage('assets/icons/heart_border_orange.png')
                )
            ),
          ),
        ),
      ),
    );
  }
}
