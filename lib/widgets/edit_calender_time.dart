
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kcpm/providers/recipe_provider.dart';
import 'package:kcpm/widgets/recipe_widget.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../models/recipe.dart';
import '../models/recipe_calendar.dart';
import '../providers/calendar_provider.dart';

class EditCalendarItem extends StatefulWidget {

  final RecipeCalendar recipeCalendar;
  final int indexRecipe;
  const EditCalendarItem({super.key, required this.recipeCalendar, required this.indexRecipe});



  @override
  State<EditCalendarItem> createState() => _EditCalendarItemState();
}

class _EditCalendarItemState extends State<EditCalendarItem> {


  late RecipeCalendar recipeCalendar;
  //late RecipeProvider recipeProvider;
  late CalendarProvider calendarProvider;

  List<Recipe>? listRecipe;

  @override
  void didChangeDependencies() {

    super.didChangeDependencies();
    //recipeProvider =  Provider.of<RecipeProvider>(context);
    calendarProvider =  Provider.of<CalendarProvider>(context);
  }

  @override
  void initState() {

    super.initState();
    recipeCalendar = widget.recipeCalendar;
    meal = recipeCalendar.meal;
    selected = widget.indexRecipe;
  }
  String? meal;
  int? selected;

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: const Text(
        'Edit Recipe Calendar',
        style: TextStyle(
          fontFamily: 'CeraPro',
        ),
      ),

      actions: [
        TextButton(
          child: const Text('Cancel',
              style: TextStyle(
                  fontFamily: 'CeraPro', color: AppColors.orangeCrusta)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text('Edit',
              style: TextStyle(
                  fontFamily: 'CeraPro', color: AppColors.orangeCrusta)),
          onPressed: () {
            if(meal == null || selected == null){
              _showDialogNotice(context);
              return;
            }

            recipeCalendar.meal = meal!;
            recipeCalendar.idRecipe = listRecipe![selected!].key;

            calendarProvider.updateRecipeCalendar(recipeCalendar);

            Navigator.pop(context);
            Navigator.pop(context);

          },
        ),
      ],

      content: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('For meals: ',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: 'CeraPro',
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(right: 60),
            child: DropdownButton<String>(
              value: meal,
              // style: const TextStyle(
              // fontFamily: 'CeraPro',
              // fontSize: 16,
              // fontWeight: FontWeight.w400
              // ),
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
                  meal = value!;
                });
              },
              items: const [
                DropdownMenuItem<String>(
                  value: "Breakfast",
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('Breakfast',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: 'CeraPro',
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.right)),
                ),
                DropdownMenuItem<String>(
                  value: 'Lunch',
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('Lunch',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: 'CeraPro',
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.right)),
                ),
                DropdownMenuItem<String>(
                  value: 'Dinner',
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('Dinner',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: 'CeraPro',
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.right)),
                ),


              ],
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Select recipe: ',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: 'CeraPro',
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Container(
            child: StreamBuilder<List<Recipe>>(
              stream: RecipeProvider().getRecipes(),
              builder: (context, snapshot) {

                if(snapshot.connectionState == ConnectionState.waiting){
                  return const CircularProgressIndicator();
                }

                else {

                  final recipes = snapshot.data;

                  setState(() {
                    listRecipe = recipes;
                  });

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: recipes!.length,
                    itemBuilder: (context, index){
                      final recipe = recipes[index];


                      return GestureDetector(
                          onTap: (){
                            setState(() {
                              selected = index;
                            });
                          },
                          child: RecipeWidget(recipe: recipe, selected: selected == index,)
                      );
                    },
                  );
                }


              }
            ),
          )
        ],
      ),
    );
  }
}


void _showDialogNotice(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Notice'),
        content: const Text('Please fill in all information!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancle',
                style: TextStyle(color: AppColors.orangeCrusta)),
          ),

        ],
      );
    },
  );
}
