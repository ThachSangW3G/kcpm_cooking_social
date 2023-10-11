
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kcpm/widgets/recipe_widget.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../models/recipe_calendar.dart';
import '../providers/calendar_provider.dart';
import '../providers/recipe_provider.dart';

class AddCalendarItem extends StatefulWidget {


  const AddCalendarItem({super.key});



  @override
  State<AddCalendarItem> createState() => _AddCalendarItemState();
}

class _AddCalendarItemState extends State<AddCalendarItem> {


  String? meal = 'Breakfast';
  int? selected;

  @override
  Widget build(BuildContext context) {

    final recipeProvider =  Provider.of<RecipeProvider>(context);
    final calendarProvider =  Provider.of<CalendarProvider>(context);
    return AlertDialog(
      title: const Text(
        'Add Recipe Calendar',
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
          child: const Text('Add',
              style: TextStyle(
                  fontFamily: 'CeraPro', color: AppColors.orangeCrusta)),
          onPressed: () {
            if(meal == null || selected == null){
              _showDialogNotice(context);
              return;
            }

            final recipeCalendar = RecipeCalendar(
                id: DateTime.now().toIso8601String(),
                idRecipe: recipeProvider.listRecipe[selected!].key,
                date: Timestamp.fromDate(calendarProvider.dateSelected),
                meal: meal!,
                idUser: FirebaseAuth.instance.currentUser!.uid
            );

            calendarProvider.addRecipeCalendar(recipeCalendar);

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
                  meal = value;
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
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: recipeProvider.listRecipe.length,
              itemBuilder: (context, index){
                final recipe = recipeProvider.listRecipe[index];

                return GestureDetector(
                    onTap: (){
                      setState(() {
                        selected = index;
                      });
                    },
                    child: RecipeWidget(recipe: recipe, selected: selected == index,)
                );
              },
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
