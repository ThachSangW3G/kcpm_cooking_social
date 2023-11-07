
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../constants/app_colors.dart';
import '../../models/recipe_calendar.dart';
import '../../providers/calendar_provider.dart';
import '../../widgets/add_calendar_item.dart';
import '../../widgets/edit_calender_time.dart';
import '../../widgets/recipe_calendar_card.dart';

class CalendarWithRecipeView extends StatefulWidget {
  final DateTime dateTime;

  const CalendarWithRecipeView({Key? key, required this.dateTime}) : super(key: key);



  @override
  State<CalendarWithRecipeView> createState() => _CalendarWithRecipeViewState();

}

class _CalendarWithRecipeViewState extends State<CalendarWithRecipeView> {

  late CalendarProvider calendarProvider;

  @override
  void didChangeDependencies() {
    calendarProvider = Provider.of<CalendarProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {


    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  // formatDate(widget.dateTime),
                  '${DateFormat.MMMM().format(calendarProvider.dateSelected)} ${calendarProvider.dateSelected.day}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500, fontFamily: 'CeraPro'),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: SvgPicture.asset('assets/icon_svg/Vector.svg', height: 24, width: 24,),
                      onPressed: () {
                        _showAddRecipeCalendarDialog(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
              height: 300,
              child: FutureBuilder<List<RecipeCalendar>>(
                  future: calendarProvider.getRecipeCalendar(calendarProvider.dateSelected, FirebaseAuth.instance.currentUser!.uid),
                  builder: (context, snapshot){
                    print(calendarProvider.dateSelected);

                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }else {
                      // print(snapshot.data);
                      // return CircularProgressIndicator();
                      final calendar = snapshot.data;

                      return ListView.builder(
                        itemCount: calendar!.length,
                        itemBuilder: (context, index){

                          final recipeCalendar = calendar![index];

                          return RecipeCalendarCard(
                            recipeCalendar: recipeCalendar,
                            option: (){
                              _showOptionMenu(context, recipeCalendar, index);
                            },

                          )
                          ;
                        },
                      );
                    }

                  }
              )
          ),
        ],
      ),
    );
  }

  String formatDate(DateTime dateTime) {
    // final weekday = DateFormat.E('vi_VN').format(dateTime);
    final weekday = DateFormat.MMMM().format(dateTime);
    final dayOfMonth = DateFormat.d('vi_VN').format(dateTime);
    return '$weekday, $dayOfMonth';
  }

  void _showOptionMenu(BuildContext context, RecipeCalendar recipeCalendar, int indexRecipe) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentTextStyle: const TextStyle(
            fontFamily: 'CeraPro',
          ),
          title: const Text(
            'Option',
            style: TextStyle(
              fontFamily: 'CeraPro',
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: SvgPicture.asset(
                  'assets/icon_svg/pencil.svg',
                  height: 20,
                  width: 20,
                ),
                title: const Text(
                  'Edit',
                  style: TextStyle(
                    fontFamily: 'CeraPro',
                  ),
                ),
                onTap: () {
                  _showEditRecipeCalendarDialog(context, recipeCalendar, indexRecipe);
                },
              ),
              ListTile(
                leading: SvgPicture.asset(
                  'assets/icon_svg/trash.svg',
                  height: 20,
                  width: 20,
                ),
                title: const Text(
                  'Delete',
                  style: TextStyle(
                    fontFamily: 'CeraPro',
                  ),
                ),
                onTap: () {
                  calendarProvider.deleteRecipeCalendar(recipeCalendar);
                  Navigator.pop(context);
                },
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Đóng',
                  style: TextStyle(
                      fontFamily: 'CeraPro', color: AppColors.orangeCrusta)),
            ),
          ],
        );
      },
    );
  }

}


void _showAddRecipeCalendarDialog(BuildContext context){
  showDialog(
      context: context,
      builder: (context){
        return const AddCalendarItem();
      }

  );

}

void _showEditRecipeCalendarDialog(BuildContext context, RecipeCalendar recipeCalendar, int indexRecipe){
  showDialog(
      context: context,
      builder: (context){
        return EditCalendarItem(recipeCalendar: recipeCalendar, indexRecipe: indexRecipe,);
      }

  );

}