
import 'package:flutter/material.dart';

import 'calendar_with_recipe_view.dart';
import 'my_new_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CalendarScreenState();

}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calendar',
          style: TextStyle(
            fontFamily: 'Recoleta',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Container(),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            MyNewCalendar(),
            CalendarWithRecipeView(dateTime: DateTime(2023, 27, 8))
          ],

        ),
      ),
    );
  }
}
