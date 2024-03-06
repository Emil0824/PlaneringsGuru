import 'package:flutter/material.dart';

class DayEvent{
  late DateTimeRange date;
  String title;
  static List<DayEvent> events = [
    DayEvent(start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 13, 0), dutration: Duration(hours:1, minutes: 15), title: "test")
    ];



  DayEvent({required DateTime start, required Duration dutration, required this.title}){
    date = DateTimeRange(
      start: start,
      end: start.add(dutration)
    );
  }
  
  static addEvent(DateTime start, Duration duration, String title){
    
      events.add(DayEvent(
        start: start, 
        dutration: duration,
        title: title
        ));
        
    
  }
}