import 'package:flutter/material.dart';

class DayEvent{



  late DateTimeRange date;
  String title;
  
  DayEvent({required DateTime start, required Duration dutration, required this.title}){
    date = DateTimeRange(
      start: start,
      end: start.add(dutration)
    );
  }
    
  
  


}