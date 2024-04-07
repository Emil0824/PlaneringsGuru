
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:planeringsguru/classes/algotithm.dart';
import 'package:planeringsguru/classes/dayEvent.dart';

class UserPreferences {


  static double workTimeShifter = 0;
  static double desiredAmountPerDay = 1;
  static double breakTime = 30;

  static int startOfDay = 8;
  static int endOfDay = 20;


  static void weighAdjust(DayEvent event){
    DateTimeRange spann = DateTimeRange(start: event.date.start.subtract(Duration(days: 1)), end: event.date.start.add(Duration(days: 1)));
    List<DayEvent> scheduleInspann = [];
    scheduleInspann.addAll(DayEvent.getEventsInSpann(spann));
    scheduleInspann.addAll(DayEvent.getLooseEvent(spann));

    List<double> calcavgGaps = Algorithm.calcavgGaps(scheduleInspann, spann);
    breakTime += (calcavgGaps[0]-breakTime).sign * (1 - (calcavgGaps[1]/ 100)) * 5;



    List<int> nonoValues = [];
    
    DateTime now = DateTime.now();
    DateTimeRange spann2 = DateTimeRange(start: DateTime.utc(now.year, now.month, now.day+1), end: DateTime.utc(now.year, now.month, now.day + 2));
    nonoValues.addAll(Algorithm.getNoNoValues(event, spann2));
    print(nonoValues);
    
    List<double> positionOnDay = Algorithm.calcavgDistance2am(nonoValues);
    workTimeShifter += (positionOnDay[2] - 12 - workTimeShifter) * 0.05;

    print("workTimeShifter: $workTimeShifter because time is " + positionOnDay[2].toString());
    print("breakTime :$breakTime [0] :${calcavgGaps[0]} [1] :${calcavgGaps[1]}");
  }
}