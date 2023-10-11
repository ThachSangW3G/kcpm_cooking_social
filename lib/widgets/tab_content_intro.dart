
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../models/recipe.dart';
import '../routes/app_routes.dart';

class TabContentIntro extends StatefulWidget {
  final Recipe? recipe;
  const TabContentIntro({Key? key, required this.recipe}) : super(key: key);

  @override
  State<TabContentIntro> createState() => _TabContentIntroState();
}

class _TabContentIntroState extends State<TabContentIntro> {
  String? _description;
  String? _source;

  @override
  void initState() {
    _description = widget.recipe?.description;
    _source = widget.recipe?.source;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _description!,
            style: const TextStyle(
                color: Colors.black,
                fontFamily: 'CeraPro',
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 15,
          ),
          const Text(
            'Source',
            style: TextStyle(
                fontSize: 20,
                fontFamily: 'CeraPro',
                fontWeight: FontWeight.w600,
                color: Colors.black),
          ),
          const SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, RouteGenerator.webviewScreen,
                  arguments: _source!);
            },
            child: Text(
              _source!,
              style: const TextStyle(
                  fontFamily: 'CeraPro',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.greyBombay),
            ),
          )
        ],
      ),
    );
  }
}
