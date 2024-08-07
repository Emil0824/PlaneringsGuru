
// ignore_for_file: file_names

import 'package:flutter/material.dart';

class DayEvent{
  late DateTimeRange date;
  String title;
  bool isAuto;
  bool isOptional = false;


  //list of all personaly planned events
  static List<DayEvent> events = [
    DayEvent(start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 8, 0), duration: const Duration(hours:4), title: "Cyckel utflykt", isAuto: false),
    DayEvent(start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 14, 0), duration: const Duration(hours:3), title: "Picknick", isAuto: true),
    DayEvent(start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1, 8, 0), duration: const Duration(hours:3), title: "Hund parken", isAuto: false),
    DayEvent(start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1, 14, 0), duration: const Duration(hours:4), title: "IKEA", isAuto: true),
    DayEvent(start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 2, 10, 0), duration: const Duration(hours:2), title: "Möte med Jens", isAuto: false),
    DayEvent(start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 2, 14, 0), duration: const Duration(minutes: 30), title: "Ring doktor", isAuto: true),
    DayEvent(start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 2, 17, 0), duration: const Duration(hours:1, minutes: 30), title: "Hämta barn på dagis", isAuto: false),
    DayEvent(start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 3, 8, 30), duration: const Duration(hours:1), title: "Sprint utverdering", isAuto: false),
    DayEvent(start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 3, 15, 0), duration: const Duration(hours:1), title: "Möte med HR", isAuto: false),
    DayEvent(start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 4, 9, 30), duration: const Duration(hours:6), title: "Skapa jira tickets", isAuto: true),
  ];



  DayEvent({required DateTime start, required Duration duration, required this.title, required this.isAuto, bool? isOptional}){
    date = DateTimeRange(
      start: start,
      end: start.add(duration),
    );
    
    if(isOptional != null){
      this.isOptional = isOptional;
    }
  }

  
  Map toJson() => {
  'start': date.start.toIso8601String(),
  'end': date.end.toIso8601String(),
  'title': title,
  'isAuto': isAuto,
  'isOptional': isOptional
  };


  factory DayEvent.fromJson(Map<String, dynamic> json) {
    return DayEvent(
      start: DateTime.parse(json['start']),
      duration: DateTime.parse(json['end']).difference(DateTime.parse(json['start'])),
      title: json['title'],
      isAuto: json['isAuto'],
      isOptional: json['isOptional'] ?? false,
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

  static removeEvent(DayEvent event){
    events.remove(event);
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

  static List<DayEvent> getEventsInSpannAndRemove(DateTimeRange spann){
    List<DayEvent> looseStuff = [];
    for (var current in events) {
      if (!current.isAuto && current.date.start.isAfter(spann.start) && current.date.end.isBefore(spann.end)){
        looseStuff.add(current);
      }
    }

    for (var element in looseStuff) {
      events.remove(element);
    }

    return looseStuff;
  }

  static List<DayEvent> getLooseEventAndRemove(DateTimeRange spann){
    List<DayEvent> looseStuff = [];
    for (var current in events) {
      if (current.isAuto && current.date.start.isAfter(spann.start) && current.date.end.isBefore(spann.end)){
        looseStuff.add(current);
      }
    }

    for (var element in looseStuff) {
      events.remove(element);
    }

    return looseStuff;
  }

  static List<DayEvent> getLooseEvent(DateTimeRange spann){
    List<DayEvent> looseStuff = [];
    for (var current in events) {
      if (current.isAuto && current.date.start.isAfter(spann.start) && current.date.end.isBefore(spann.end)){
        looseStuff.add(current);
      }
    }

    return looseStuff;
  }

  static List<DayEvent> getEventsInSpann(DateTimeRange spann){
    List<DayEvent> eventStuff = [];
    for (var current in events) {
      if (!current.isAuto && current.date.start.isAfter(spann.start) && current.date.end.isBefore(spann.end)){
        eventStuff.add(current);
       
      }
    }

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

