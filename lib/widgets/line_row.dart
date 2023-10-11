
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class LineRow extends StatelessWidget {
  const LineRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      thickness: 1.4,
      color: AppColors.greyIron,
    );
  }
}
