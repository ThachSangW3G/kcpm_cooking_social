import 'package:flutter/material.dart';
import 'package:kcpm/models/user.dart';
import 'package:kcpm/screens/authentication/login_screen.dart';
import 'package:kcpm/screens/bottom_navigation/bottom_navigation.dart';
import 'package:kcpm/screens/home/home_screen.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

    if (user == null){
      return const LoginScreen();
    } else{
      return const BottomNavigation();
    }
  }
}
