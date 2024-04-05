
// ignore_for_file: file_names

import 'package:flutter/material.dart';

class DayEvent{
  late DateTimeRange date;
  String title;
  bool isAuto;



  //list of all personaly planned events
  static List<DayEvent> events = [
    DayEvent(start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 13, 0), duration: const Duration(hours:1, minutes: 15), title: "tes1", isAuto: false),
    DayEvent(start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 16, 0), duration: const Duration(hours:1, minutes: 15), title: "tes2", isAuto: true),
    DayEvent(start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 12, 0).add(const Duration(days: 1)), duration: const Duration(hours:1, minutes: 15), title: "tes3", isAuto: true),
  ];



  DayEvent({required DateTime start, required Duration duration, required this.title, required this.isAuto}){
    date = DateTimeRange(
      start: start,
      end: start.add(duration),
    );
  }


  //add check for collsion in looseEvents if yes move loose events

  static addEventFields(DateTime start, Duration duration, String title, bool isAuto){
    DayEvent tmp = DayEvent(
      start: start, 
      duration: duration,
      title: title,
      isAuto: isAuto
    );

    addEvent(tmp);
  }


  static addEvent(DayEvent event){
    int counter = 0;
   
    while(true){
      if (counter >= events.length){
        events.add(event);
        break;
      }
      else if(events[counter].date.start.isAfter(event.date.start)){
        events.insert(counter , event);
        break;
      }

      counter++;
    }
        

  }


  static List<DayEvent> getEvents(){
    return events;
  }

  static List<DayEvent> getLooseEvent(DateTimeRange spann){
    List<DayEvent> looseStuff = [];
    events.forEach((current) {
      if (current.isAuto && current.date.start.isAfter(spann.start) && current.date.end.isBefore(spann.end)){
        looseStuff.add(current);
      }
    });

    looseStuff.forEach((element) {
      events.remove(element);
    });

    return looseStuff;
  }

  static List<DayEvent> getEventsInSpann(DateTimeRange spann){
    List<DayEvent> eventStuff = [];
    events.forEach((current) {
      if (!current.isAuto && current.date.start.isAfter(spann.start) && current.date.end.isBefore(spann.end)){
        eventStuff.add(current);
       
      }
    });

    return eventStuff;
  }

/*
  static addLooseEvent(DayEvent event){
    looseEvents.add(event);
  }
*/
  static moveLooseEvent(){
    
  }

  int collisionCheck(DayEvent b){
    if((date.start.isBefore(b.date.start) && date.end.isAfter(b.date.start)) || (date.start.isAfter(b.date.start) && b.date.end.isAfter(date.start))){
      return 0;
    }
    else if(date.start.isBefore(b.date.start)){
      return -1;
    }
    else if(date.start.isAfter(b.date.start)){
      return 1;
    }
    else {
      throw Error();
    }
  }
}

