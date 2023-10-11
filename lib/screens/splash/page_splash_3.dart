import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class PageSplash3 extends StatefulWidget {
  const PageSplash3({super.key});

  @override
  State<PageSplash3> createState() => _PageSplash3State();
}

class _PageSplash3State extends State<PageSplash3> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 400,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/background_splash_3.jpg'),
                  fit: BoxFit.cover)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigator.pushNamed(
                      //   context,
                      //   RouteGenerator.bottom_navigation,
                      // );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 30),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          color: Colors.black),
                      child: const Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                        child: Center(
                          child: Text(
                            'Skip',
                            style: TextStyle(
                                color: Colors.white, fontFamily: "CeraPro"),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 300),
          width: double.infinity,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60), topRight: Radius.circular(60)),
              color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          width: 2,
                          color: AppColors.greyBombay.withOpacity(0.5))),
                  child: const Center(
                    child: Image(
                      image: AssetImage('assets/icons/hatchef.png'),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  'Cook from your favorite device',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'CeraPro',
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Mallika stores your recipes in the Cloud so you can access them on any device through our website or Android/iOS app.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'CeraPro',
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
