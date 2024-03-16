import 'package:flutter/material.dart';
import 'package:planeringsguru/classes/dayEvent.dart';


class Algorithm{



  static planEvent(String title, Duration dutration){
    DayEvent.addLooseEvent(
      DayEvent(
        start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 13, 0).add(Duration(days: 1)), 
        dutration: dutration, 
        title: title, 
        isAuto: true
      )
    );
  }
}