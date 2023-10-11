
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kcpm/screens/search/search_screen.dart';

import '../../constants/app_colors.dart';
import '../../routes/app_routes.dart';
import '../calendar/calender_screen.dart';
import '../grocery/grocery_screen.dart';
import '../home/home_screen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int currentTab = 0;
  final List<Widget> screens = [
    const HomeScreen(),
    const SearchRecipeScreen(),
    const GroceryScreen(),
    const CalendarScreen(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.orangeCrusta,
        foregroundColor: AppColors.whitePorcelain,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          size: 25,
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(
            RouteGenerator.recipeaddScreen,
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 50,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 7),
        shape: const CircularNotchedRectangle(),
        notchMargin: 20,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      currentScreen = const HomeScreen();
                      currentTab = 0;
                    });
                  },
                  child: SvgPicture.asset(
                    'assets/icon_svg/home.svg',
                    color:
                    currentTab == 0 ? AppColors.orangeCrusta : Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                     currentScreen = const SearchRecipeScreen();
                     currentTab = 1;
                    });
                  },
                  child: SvgPicture.asset(
                    'assets/icon_svg/search.svg',
                    color:
                    currentTab == 1 ? AppColors.orangeCrusta : Colors.black,
                  ),
                ),
              ),
              Container(
                width: 70,
              ),
              Expanded(
                child: MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      currentScreen = const GroceryScreen();
                      currentTab = 2;
                    });
                  },
                  child: SvgPicture.asset(
                    'assets/icon_svg/cart.svg',
                    color:
                    currentTab == 2 ? AppColors.orangeCrusta : Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      currentScreen = const CalendarScreen();
                      currentTab = 3;
                    });
                  },
                  child: SvgPicture.asset(
                    'assets/icon_svg/calendar.svg',
                    color:
                    currentTab == 3 ? AppColors.orangeCrusta : Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
