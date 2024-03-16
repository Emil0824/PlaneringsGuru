import 'package:flutter/material.dart';

class DayEvent{
  late DateTimeRange date;
  String title;
  bool isAuto;

  //list of all personaly planned events
  static List<DayEvent> events = [
    DayEvent(start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 13, 0), dutration: Duration(hours:1, minutes: 15), title: "test", isAuto: false),

  ];
    
  //list of all algorithmithm planned events
  static List<DayEvent> looseEvents = [
    DayEvent(start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 16, 0), dutration: Duration(hours:1, minutes: 15), title: "test", isAuto: true),
    DayEvent(start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 12, 0).add(Duration(days: 1)), dutration: Duration(hours:1, minutes: 15), title: "test", isAuto: true),

  ]; 


  DayEvent({required DateTime start, required Duration dutration, required this.title, required this.isAuto}){
    date = DateTimeRange(
      start: start,
      end: start.add(dutration),
    );
  }
  
  //add check for collsion in looseEvents if yes move loose events
  static addEvent(DateTime start, Duration duration, String title, bool isAuto){
    
    events.add(DayEvent(
      start: start, 
      dutration: duration,
      title: title,
      isAuto: isAuto
    ));
        
  
  }


  static getEvents(){
    List<DayEvent> temp = events.toList();
    temp.addAll(looseEvents);

    return temp;
  }

  static addLooseEvent(DayEvent event){
    looseEvents.add(event);
  }

  static moveLooseEvent(){
    
  }
}