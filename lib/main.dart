import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kcpm/constants/app_colors.dart';
import 'package:kcpm/firebase_options.dart';
import 'package:kcpm/models/user.dart';
import 'package:kcpm/providers/add_recipe_provider/intro_provider.dart';
import 'package:kcpm/providers/add_recipe_provider/material_provider.dart';
import 'package:kcpm/providers/add_recipe_provider/spice_provider.dart';
import 'package:kcpm/providers/add_recipe_provider/steps_provider.dart';
import 'package:kcpm/providers/calendar_provider.dart';
import 'package:kcpm/providers/category_provider.dart';
import 'package:kcpm/providers/like_provider.dart';
import 'package:kcpm/providers/like_review_provider.dart';
import 'package:kcpm/providers/recipe_provider.dart';
import 'package:kcpm/providers/review_provider.dart';
import 'package:kcpm/providers/theme_provider.dart';
import 'package:kcpm/providers/user_provider.dart';
import 'package:kcpm/routes/app_routes.dart';
import 'package:kcpm/screens/authentication/login_screen.dart';
import 'package:kcpm/screens/authentication/sign_up_screen.dart';
import 'package:kcpm/screens/authentication/wrapper.dart';
import 'package:kcpm/screens/splash/page_splash_1.dart';
import 'package:kcpm/screens/splash/splash_screen.dart';
import 'package:kcpm/services/auth.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
        ChangeNotifierProvider(create: (_) => LikeReviewProvider(firestore: FirebaseFirestore.instance)),
        ChangeNotifierProvider(create: (_) => CalendarProvider(firestore:  FirebaseFirestore.instance)),
        ChangeNotifierProvider(create: (_) => RecipeProvider(firestore: FirebaseFirestore.instance)),
        ChangeNotifierProvider(create: (_) => StepsProvider()),
        ChangeNotifierProvider(create: (_) => SpiceProvider()),
        ChangeNotifierProvider(create: (_) => MaterialProvider()),
        ChangeNotifierProvider(create: (_) => IntroProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider(firestore: FirebaseFirestore.instance)),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider(firestore: FirebaseFirestore.instance)),
        ChangeNotifierProvider(create: (_) => LikeProvider(firestore: FirebaseFirestore.instance)),
      ],
      child: const MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
      value: AuthService(auth: FirebaseAuth.instance).user,
      initialData: null,
      child: MaterialApp(
        title: 'Cooking Social',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.orange),
          useMaterial3: true,
        ),
        onGenerateRoute: RouteGenerator.generatorRoute,
        home: const Wrapper(),
      ),
    );
  }
}
