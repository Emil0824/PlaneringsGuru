import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MonthSchedule extends StatefulWidget{


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
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
          ),
          SizedBox(height: 20),
        ]
      ),
    );
  }
}