
import 'package:flutter/material.dart';
import 'package:kcpm/screens/authentication/sign_up_screen.dart';
import 'package:page_transition/page_transition.dart';

import '../models/recipe.dart';
import '../screens/account/account_screen.dart';
import '../screens/account/liked_recipe_screen.dart';
import '../screens/account/notification_screen.dart';
import '../screens/account/setting_screen.dart';
import '../screens/authentication/login_screen.dart';
import '../screens/bottom_navigation/bottom_navigation.dart';
import '../screens/home/home_screen.dart';
import '../screens/recipe/detail_recipe.dart';
import '../screens/recipe/recipe_add_screen.dart';
import '../screens/recipe/reivew_screen.dart';
import '../screens/splash/splash_screen.dart';

class RouteGenerator {
  const RouteGenerator._();

  static Route<dynamic> generatorRoute(RouteSettings settings) {
    final args = settings.arguments;
    //final AuthService _authService = AuthService();
    switch (settings.name) {
      case home:
        return PageTransition(
          child: const SafeArea(child: SafeArea(child: HomeScreen())),
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: 400),
        );

      case splash:
        return PageTransition(
          child: const SafeArea(child: SafeArea(child: SplashScreen())),
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: 400),
        );

      // case detailCookbook:
      //   CookBook cookbook = args as CookBook;
      //   return PageTransition(
      //     child: SafeArea(
      //         child: SafeArea(
      //             child: DetailCookBookScreen(
      //               cookbook: cookbook,
      //             ))),
      //     type: PageTransitionType.fade,
      //     duration: const Duration(milliseconds: 400),
      //   );

      // case community:
      //   return PageTransition(
      //     child: const SafeArea(child: SafeArea(child: CommunityScreen())),
      //     type: PageTransitionType.fade,
      //     duration: const Duration(milliseconds: 400),
      //   );

      case bottom_navigation:
        return PageTransition(
          child: const SafeArea(child: SafeArea(child: BottomNavigation())),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 400),
        );

      case login:
        return PageTransition(
          child: const SafeArea(child: SafeArea(child: LoginScreen())),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 400),
        );
      case sign_up_email:
        return PageTransition(
          child: const SafeArea(child: SafeArea(child: SignUpScreen())),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 400),
        );
      // case authentication:
      //   return PageTransition(
      //     child: const SafeArea(child: SafeArea(child: AuthenticationScreen())),
      //     type: PageTransitionType.fade,
      //     duration: const Duration(milliseconds: 400),
      //   );

    case accountScreen:
      return PageTransition(
        child: const SafeArea(child: SafeArea(child: AccountScreen())),
        type: PageTransitionType.rightToLeft,
        duration: const Duration(milliseconds: 400),
      );

      // case accountScreen:
      //   return PageTransition(
      //     child: SafeArea(
      //         child: SafeArea(
      //             child: BlocProvider<AuthenticationBloc>(
      //               create: (context) => AuthenticationBloc(authService: _authService),
      //               child: const AccountScreen(),
      //             ))),
      //     type: PageTransitionType.rightToLeft,
      //     duration: const Duration(milliseconds: 400),
      //   );
      //
      case notificationScreen:
        return PageTransition(
          child: const SafeArea(child: SafeArea(child: NotificationScreen())),
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: 400),
        );
      case settingScreen:
      return PageTransition(
        child: const SafeArea(child: SafeArea(child: SettingScreen())),
        type: PageTransitionType.rightToLeft,
        duration: const Duration(milliseconds: 400),
      );
      // case interfacesettingScreen:
      //   return PageTransition(
      //     child: const SafeArea(child: SafeArea(child: InterfaceSettingScreen())),
      //     type: PageTransitionType.rightToLeft,
      //     duration: const Duration(milliseconds: 400),
      //   );
      // case notisettingScreen:
      //   return PageTransition(
      //     child: const SafeArea(child: SafeArea(child: NotiSettingScreen())),
      //     type: PageTransitionType.rightToLeft,
      //     duration: const Duration(milliseconds: 400),
      //   );
      // case languagesettingScreen:
      //   return PageTransition(
      //     child: const SafeArea(child: SafeArea(child: LanguageSettingScreen())),
      //     type: PageTransitionType.rightToLeft,
      //     duration: const Duration(milliseconds: 400),
      //   );
      // case accountpersonScreen:
      //   String idUser = args as String;
      //   return PageTransition(
      //     child: SafeArea(
      //         child: SafeArea(
      //             child: AccountPerSonScreen(
      //               idUser: idUser,
      //             ))),
      //     type: PageTransitionType.rightToLeft,
      //     duration: const Duration(milliseconds: 400),
      //   );
      // case editprofileScreen:
      //   String idUser = args as String;
      //   return PageTransition(
      //     child: SafeArea(
      //         child: SafeArea(
      //             child: EditProfileScreen(
      //               idUser: idUser,
      //             ))),
      //     type: PageTransitionType.rightToLeft,
      //     duration: const Duration(milliseconds: 400),
      //   );
      case likedrecipeScreen:
        return PageTransition(
          child: const SafeArea(child: SafeArea(child: LikedRecipeScreen())),
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: 400),
        );
      case recipedetailScreen:
        Map<String, dynamic>? argsMap = args as Map<String, dynamic>?;
        String key = argsMap!['key'] as String;
        String uid = argsMap['uid'] as String;
        return PageTransition(
          child: SafeArea(
              child: SafeArea(
                  child: RecipeDetailsScreen(
                    keyRecipe: key,
                    uidRecipe: uid,
                  ))),
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: 400),
        );
      // case webviewScreen:
      //   String url = args as String;
      //   return PageTransition(
      //     child: SafeArea(child: SafeArea(child: NewsWebViewPage(url: url))),
      //     type: PageTransitionType.rightToLeft,
      //     duration: const Duration(milliseconds: 400),
      //   );
      case reviewScreen:
        Recipe recipe = args as Recipe;
        return PageTransition(
          child: SafeArea(
              child: SafeArea(
                  child: ReViewScreen(
                    recipe: recipe,
                  ))),
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: 400),
        );
      // case recipeeditScreen:
      //   Recipe? recipe = args as Recipe?;
      //   return PageTransition(
      //     child: SafeArea(
      //         child: SafeArea(
      //             child: RecipeEditScreen(
      //               recipe: recipe,
      //             ))),
      //     type: PageTransitionType.rightToLeft,
      //     duration: const Duration(milliseconds: 400),
      //   );
      // case recipeaddgroceryScreen:
      //   Recipe? recipe = args as Recipe;
      //   return PageTransition(
      //     child: SafeArea(child: SafeArea(child: AddGroceryScreen(recipe: recipe,))),
      //     type: PageTransitionType.rightToLeft,
      //     duration: const Duration(milliseconds: 400),
      //   );
      case recipeaddScreen:
        return PageTransition(
          child: const SafeArea(child: SafeArea(child: RecipeAddScreen())),
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: 400),
        );
      // case calendarScreen:
      //   return PageTransition(
      //     child: const SafeArea(child: SafeArea(child: CalendarScreen())),
      //     type: PageTransitionType.rightToLeft,
      //     duration: const Duration(milliseconds: 400),
      //   );
      //
      // case addCookbookScreen:
      //   return PageTransition(
      //     child: const SafeArea(child: SafeArea(child: AddCookbookScreen())),
      //     type: PageTransitionType.rightToLeft,
      //     duration: const Duration(milliseconds: 400),
      //   );

    //

      default:
        throw const RouteException("Route not found");
    }
  }

  static const splash = '/splash';

  static const home = '/home';
  static const detailCookbook = '/detailCookbook';
  static const community = '/community';
  static const bottom_navigation = '/bottom_navigation';
  static const login = '/login';
  static const sign_up_email = '/sign_up_email';
  static const authentication = '/authentication';

  // ACCOUNT
  static const accountScreen = '/account';
  static const notificationScreen = '/notification';
  static const accountpersonScreen = '/accountperson';
  static const editprofileScreen = '/editprofile';
  static const likedrecipeScreen = '/likedrecipe';

  //SETTINGS
  static const settingScreen = 'settings';
  static const interfacesettingScreen = 'interfacesetting';
  static const notisettingScreen = 'nitificationssetting';
  static const languagesettingScreen = 'languagesetting';
  static const aboutScreen = 'aboutSetting';
  static const helpsupportScreen = 'helpsupportSetting';
  static const sendfeedbackScreen = 'sendfeedbackSetting';
  static const rateusScreen = 'rateusSetting';
  static const checkforupdateScreen = 'checkforupdateSetting';


  // RECIPE DETAILS
  static const recipedetailScreen = '/recipedetail';
  static const reviewScreen = '/review';
  static const webviewScreen = '/webview';

  //RECIPE EDIT
  static const recipeeditScreen = '/recipededit';
  static const recipeaddgroceryScreen = '/recipeeditaddgrocery';

  //RECIPE ADD
  static const recipeaddScreen = '/recipeadd';

  //GROCERY
  static const groceryScreen = '/grocery';

  //CALENDAR
  static const calendarScreen = '/calendar';

  static const addCookbookScreen = '/add_cookbook';
}

class RouteException implements Exception {
  final String message;
  const RouteException(this.message);
}
