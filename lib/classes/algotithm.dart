import 'dart:math';

import 'package:flutter/material.dart';
import 'package:planeringsguru/classes/dayEvent.dart';


class Algorithm{

  static planEvent(String title, Duration dutration){
    DateTime now = DateTime.now();
    DateTimeRange spann = DateTimeRange(start: DateTime(now.year, now.month,now.day + 1, 0, 0), end: DateTime(now.year, now.month,now.day + 4, 0, 0));
    planSpannedEvent(title, dutration, spann);
  }

  static planSpannedEvent(String title, Duration duration, DateTimeRange spann){

    DayEvent tempDayEvent = DayEvent(
      start: DateTime.now(), 
      duration: duration,
      title: title,
      isAuto: true
    );
    
    
    List<DayEvent> looseEvents = DayEvent.getLooseEvent(spann);
    looseEvents.add(tempDayEvent);
    
    planList(looseEvents, spann);

  }


  static planList(List<DayEvent> looseEvents, DateTimeRange spann){
    List<List<DayEvent>> arrayOfSchemas = [];
    List<DayEvent> staticEvents = DayEvent.getEventsInSpann(spann);

    /*time in int
    day 1
    00:00 = 0
    00:05 = 1
    01:00 = 12
    08:00 = 96
    12:00 = 144
    20:00 = 240
    23:59 = 287
    day 2 
    00:00 = 288
    12:00 = 432
    23:59 = 575
    day 3
    00:00 = 576
    */
    List<int> nonoValues = [];
    int spannTime = (spann.duration.inMinutes / 5).toInt();

    staticEvents.forEach((current) {
      nonoValues.addAll(getNoNoValues(current, spann));
    });

    //generate random times
    for (int i = 0; i < 100; i++){
      arrayOfSchemas.add(staticEvents);
      looseEvents.forEach((current) {
        int durrTime = (current.date.duration.inMinutes / 5).toInt();

        bool okSpot = false;
        while (!okSpot) {
          int startTime = Random().nextInt(spannTime - durrTime);

          if (!nonoValues.contains(startTime) && !nonoValues.contains(startTime + durrTime/2) && !nonoValues.contains(startTime + durrTime)){
            okSpot = true;
            print(startTime);
            DayEvent randEvent = DayEvent(start: DateTime.now().add(Duration(days: startTime %= 288, hours: startTime %= 12, minutes: startTime)), duration: current.date.duration, title: current.title, isAuto: true);
            arrayOfSchemas[i].add(randEvent);
            nonoValues.addAll(getNoNoValues(randEvent, spann));
          }   
        }
      });
    }



    //find good schemas from arrayOfSchemas
    
  }

  static List<int> getNoNoValues(DayEvent event, DateTimeRange spann){
    List<int> nonoValues = [];

    int minuteTime = event.date.start.minute - spann.start.minute;
    int hourTime = event.date.start.hour - spann.start.hour;
    int dayTime = event.date.start.day - spann.start.day;
    int durrTime = (event.date.duration.inMinutes / 5).toInt();

    int startTime = ((minuteTime/5).toInt()) + (hourTime * 12) + (dayTime * 288);
    for (int i = startTime; i <= startTime + durrTime; i++){
      nonoValues.add(i);
    }

    return nonoValues;
  }

  
}
