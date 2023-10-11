
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../constants/app_colors.dart';
import '../../providers/calendar_provider.dart';

class MyNewCalendar extends StatefulWidget {
  const MyNewCalendar({super.key});

  @override
  State<StatefulWidget> createState() => _MyNewCalendarState();

}

class _MyNewCalendarState extends State<MyNewCalendar> {
  DateTime _focusedDay = DateTime.now();

  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {

    final calendarProvider = Provider.of<CalendarProvider>(context);

    return Container(
      decoration: const BoxDecoration(
          color: AppColors.greyIron
      ),
      padding: const EdgeInsets.only(bottom: 8),
      child: TableCalendar(
        focusedDay: _focusedDay,
        firstDay: DateTime(2023, 1, 1),
        lastDay: DateTime(2023, 12, 31),
        calendarFormat: CalendarFormat.week,
        startingDayOfWeek: StartingDayOfWeek.monday,
        calendarStyle: const CalendarStyle(
            selectedDecoration: BoxDecoration(color: AppColors.orangeCrusta, shape: BoxShape.circle),
            todayDecoration: BoxDecoration(color: Colors.transparent, shape: BoxShape.circle),
            todayTextStyle: TextStyle(color: AppColors.orangeCrusta, )
        ),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = selectedDay;

            calendarProvider.selectDate(_selectedDay);
          });

        },
        selectedDayPredicate: (day) =>
            isSameDay(day, _selectedDay)
        ,
        onFormatChanged:(format) {

        },
        headerStyle: HeaderStyle(
            titleTextStyle: const TextStyle(
              fontFamily: 'Recoleta',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            formatButtonVisible: false,
            titleTextFormatter: (date, locale) => DateFormat.MMMM(locale).format(date),
            leftChevronPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 5),
            rightChevronPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 5)
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
            weekdayStyle: TextStyle(fontFamily: 'CeraPro', fontSize: 14, fontWeight: FontWeight.w500)
        ),


      ),
    );



  }

}

