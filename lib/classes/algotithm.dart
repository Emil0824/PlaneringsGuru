import 'package:flutter/material.dart';
import 'package:planeringsguru/classes/dayEvent.dart';


class Algorithm{

  static planEvent(String title, Duration dutration){
    DateTime now = DateTime.now();
    DateTimeRange spann = DateTimeRange(start: now, end: DateTime(now.year, now.month,now.day + 4, 0, 0));
    planSpannedEvent(title, dutration, spann);
  }

  static planSpannedEvent(String title, Duration duration, DateTimeRange spann){
    List<DayEvent> events = DayEvent.getEvents();
    
    DateTime plannedStart = spann.start;
    
    DayEvent tempDayEvent;

    for (int i = 0; i < events.length; i++) {
      if(events[i].date.start.isAfter(spann.start) || plannedStart.add(duration).isBefore(spann.end)){
        
        tempDayEvent = DayEvent(
          start: plannedStart, 
          duration: duration,
          title: title,
          isAuto: true
        );

        
        if (tempDayEvent.collisionCheck(events[i]) == 0){
          plannedStart = events[i].date.end.add(const Duration(minutes: 15)); //here "buffer" time ex 15 minutes
        }

      }



      if(events[i].date.start.isAfter(spann.end)){
        
      }
    }
    
    
    
    
    
    
    
      



    DayEvent.addEvent(
      DayEvent(
        start: plannedStart, 
        duration: duration, 
        title: title, 
        isAuto: true
      )
    );
  }
}