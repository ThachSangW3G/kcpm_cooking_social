
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/app_colors.dart';
import '../../models/recipe.dart';
import '../../routes/app_routes.dart';
import '../../widgets/recipe_sumary.dart';
import '../../widgets/tab_content_ingredients.dart';
import '../../widgets/tab_content_intro.dart';
import '../../widgets/tab_content_steps.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final String uidRecipe;
  final String keyRecipe;
  const RecipeDetailsScreen(
      {super.key, required this.keyRecipe, required this.uidRecipe});

  @override
  State<RecipeDetailsScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<RecipeDetailsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();
  Recipe? recipeSet;
  //late CalendarProvider calendarProvider;

  @override
  void didChangeDependencies() {
    //calendarProvider = Provider.of<CalendarProvider>(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);

    //context.read<RecipeStateProvider>().fetchRecipe(widget.keyRecipe);
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   context.read<RecipeStateProvider>().fetchRecipe(widget.keyRecipe);
  //   super.didChangeDependencies();
  // }

  DateTime date = DateTime.now();
  String? meal = 'Breakfast';

  _showDatePicker() {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2025))
        .then((value) {
      setState(() {
        date = value!;
        _showDialogChooseMeal(context);
      });
    });
  }

  void _showDialogChooseMeal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('For meal'),
              content: Container(
                height: 100,
                child: DropdownButton<String>(
                  value: meal,
                  underline: const Divider(
                    thickness: 1.5,
                    color: AppColors.greyBombay,
                  ),
                  isExpanded: true,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 8),
                  icon: Align(
                    alignment: Alignment.centerRight,
                    child: SvgPicture.asset(
                      'assets/icon_svg/chevron-circle-down.svg',
                      height: 15,
                      width: 8,
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      meal = value;
                    });
                  },
                  items: const [
                    DropdownMenuItem<String>(
                      value: "Breakfast",
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Breakfast',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: 'CeraPro',
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Lunch',
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Lunch',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: 'CeraPro',
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Dinner',
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Dinner',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: 'CeraPro',
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.orangeCrusta),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // final RecipeCalendar recipeCalendar = RecipeCalendar(
                    //     id: DateTime.now().toIso8601String(),
                    //     idRecipe: widget.keyRecipe,
                    //     date: Timestamp.fromDate(date),
                    //     meal: meal!,
                    //     idUser: FirebaseAuth.instance.currentUser!.uid);
                    //
                    // calendarProvider.addRecipeCalendar(recipeCalendar);

                    Navigator.pop(context);
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(color: AppColors.orangeCrusta),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final RecipeStateProvider recipeProvider =
    //     Provider.of<RecipeStateProvider>(context, listen: true);
    DocumentReference documentRef =
    FirebaseFirestore.instance.collection('recipes').doc(widget.keyRecipe);
    return Scaffold(
        backgroundColor: AppColors.whitePorcelain,
        body: Padding(
          padding: const EdgeInsets.all(0),
          child: StreamBuilder(
            stream: documentRef.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                // Hiển thị widget khi có lỗi xảy ra
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData && snapshot.data!.exists) {
                Recipe recipe = Recipe.fromJson(
                    snapshot.data!.data() as Map<String, dynamic>);
                recipeSet = recipe;
                return RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: () async {
                    //recipeProvider.fetchRecipe(widget.keyRecipe);
                    return Future<void>.delayed(const Duration(seconds: 3));
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        RecipeSummary(
                          recipe: recipe,
                        ),
                        const SizedBox(height: 15),
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 40,
                                width: double.infinity,
                                child: TabBar(
                                  controller: _tabController,
                                  indicator: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25.0),
                                    color: AppColors.orangeCrusta,
                                  ),
                                  labelColor: Colors.white,
                                  unselectedLabelColor: AppColors.greyShuttle,
                                  dividerColor: Colors.white,
                                  tabs: [
                                    Tab(
                                      child: Container(
                                        width: 100,
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Intro',
                                          style: TextStyle(
                                              fontFamily: 'CeraPro',
                                              fontSize: 17),
                                        ),
                                      ),
                                    ),
                                    // second tab [you can add an icon using the icon property]
                                    Tab(
                                      child: Container(
                                        width: 100,
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Ingredients',
                                          style: TextStyle(
                                              fontFamily: 'CeraPro',
                                              fontSize: 17),
                                        ),
                                      ),
                                    ),
                                    Tab(
                                      child: Container(
                                        width: 100,
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Steps',
                                          style: TextStyle(
                                              fontFamily: 'CeraPro',
                                              fontSize: 17),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: double.infinity,
                                child: TabBarView(
                                  controller: _tabController,
                                  children: [
                                    TabContentIntro(
                                      recipe: recipe,
                                    ),
                                    TabContentIngredients(
                                      recipe: recipe,
                                    ),
                                    TabContentSteps(
                                      recipe: recipe,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Container();
            },
          ),
        ),
        bottomNavigationBar: Container(
          height: 60,
          decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.greyIron))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              widget.uidRecipe == FirebaseAuth.instance.currentUser?.uid
                  ? GestureDetector(
                onTap: () {
                  //print(recipeSet?.description);
                  Navigator.pushNamed(
                      context, RouteGenerator.recipeeditScreen,
                      arguments: recipeSet);
                },
                child: const SizedBox(
                  height: 30,
                  width: 30,
                  child: Image(
                    image: AssetImage('assets/icons/pencil.png'),
                    color: Colors.black,
                  ),
                ),
              )
                  : GestureDetector(
                onTap: () {},
                child: const SizedBox(
                  height: 30,
                  width: 30,
                  child: Image(
                    image: AssetImage('assets/icons/pencil.png'),
                    color: AppColors.greyIron,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RouteGenerator.recipeaddgroceryScreen, arguments: recipeSet);
                  //CART NE---------------------------------------------------------------------------------------
                },
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: SvgPicture.asset(
                    'assets/icon_svg/cart.svg',
                    colorFilter:
                    const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _showDatePicker();
                },
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: SvgPicture.asset(
                    'assets/icon_svg/calendar-check.svg',
                    colorFilter:
                    const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: SvgPicture.asset(
                    'assets/icon_svg/options.svg',
                    colorFilter:
                    const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
