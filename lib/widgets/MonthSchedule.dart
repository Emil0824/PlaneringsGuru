// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:planeringsguru/classes/choosenDay.dart';


class MonthSchedule extends StatefulWidget{
  const MonthSchedule({super.key});



  @override
  State<MonthSchedule> createState() => _MonthScheduleState();
}

class _MonthScheduleState extends State<MonthSchedule> {
  DateTime _focusedDay = DateTime.now();
DateTime? _selectedDay;


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TableCalendar(
            startingDayOfWeek: StartingDayOfWeek.monday,
            focusedDay: _focusedDay, 
            firstDay: DateTime.utc(DateTime.now().year - 2, 01, 01), 
            lastDay: DateTime.utc(DateTime.now().year + 5, 12, 31),
            calendarFormat: CalendarFormat.month,
            availableCalendarFormats: const {CalendarFormat.month: 'Month',},
            
            selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` as well

                print("select: "+ _selectedDay!.day.toString());
                ChoosenDay.change(_selectedDay!);
                ChoosenDay.changeToDayViewCallBack(1);
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },


          ),
          const SizedBox(height: 20),
        ]
      ),
    );
  }
}