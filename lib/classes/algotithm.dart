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
    print("looseEvents: " + looseEvents.length.toString());
    
    
    planList(looseEvents + [tempDayEvent], spann);

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
    for (int i = 0; i < 1; i++){
      print("looseEvents: " + looseEvents.length.toString());

      arrayOfSchemas.add(staticEvents);
      looseEvents.forEach((current) {
        int durrTime = (current.date.duration.inMinutes / 5).toInt();

        bool okSpot = false;
        while (!okSpot) {
          int startTime = Random().nextInt(spannTime - durrTime);

          List<int> eventValues = [];

          for (int val = startTime; val <= startTime + durrTime; val++){
            eventValues.add(val);
          }

          if (!containsFromListToList(nonoValues, eventValues)){
            okSpot = true;
            print("startTime: $startTime");
            int day = startTime ~/ 288;
            int hour = (startTime % 288) ~/ 12;
            int minute = ((startTime % 288) % 12) * 5;

            DayEvent randEvent = DayEvent(start: DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1 + day, hour, minute), duration: current.date.duration, title: current.title, isAuto: true);
            arrayOfSchemas[i].add(randEvent);
            nonoValues.addAll(getNoNoValues(randEvent, spann));
          }   
        }
      });
    }

    //find good schemas from arrayOfSchemas
    /*
    Evenly spread? ie about the same amount of things on every day
    Gaps are not too large?
    Time of day? when stuff is happening
    */
    
    int a = 1,b = 1,c = 1;
    

    int score;

    int sumGaps = calcsumGaps(arrayOfSchemas[0], spann); //compactness
    int deltaMostFewEvents = calcdeltaMostFewEvents(arrayOfSchemas[0], spann); //events per day diff
    int avgDistanceMidnight = calcavgDistance2am(nonoValues); //how close to the middle of the day are things planned

    print("sumGaps: $sumGaps \n");
    print("deltaMostFewEvents: $deltaMostFewEvents \n");
    print("avgDistanceMidnight: $avgDistanceMidnight \n");


    /*
    show = {[a,30][b,35][c,45]}
    {d,25}
    */
    score = sumGaps + deltaMostFewEvents + avgDistanceMidnight;

    DayEvent.events += arrayOfSchemas[0];
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

  static bool containsFromListToList(List<int> nonoValues, List<int> eventValues){
    bool status = false;

    for (var element in eventValues) {
      if (nonoValues.contains(element)) {
        status = true;
        break;
      }
    }

    return status;
  }

  static int calcavgDistance2am(List<int> occupiedSlots){
    //sum the distance of all events from midnight divided by the number of events
    double totscore = 0;

    for (int current in occupiedSlots) {
      double temp = (current % 288)/12;

      //mega nice equation
      totscore += (100) / (1 + exp(-1.6 * (temp - 8.3)) + exp(1.2 * (temp - 18)));
    }
    int score = totscore ~/ occupiedSlots.length;
    
    return score;
  }

  static int calcsumGaps(List<DayEvent> schema, DateTimeRange spann){
    int score = 0;
    int numDays = spann.duration.inDays;
    int sum = 0;
    List<List<List<int>>> collectionofStartEnd = [[[]]];
    List<int> startEnd =[];
    DateTime firstDay = DateTime.now().add(Duration(days: 1));
    //Gaps between events of the same day
    for (int i = 0; i < numDays; i++){
      collectionofStartEnd.add([]);
      for (DayEvent element in schema) {
        if(element.date.start.day == firstDay.add(Duration(days: i)).day){
          startEnd =[];
          startEnd.add(element.date.start.hour * 60 + element.date.start.minute);
          startEnd.add(element.date.end.hour * 60 + element.date.end.minute);
          collectionofStartEnd[i].add(startEnd);
        }
      }
    }

    for (List<List<int>> element in collectionofStartEnd){
      sortSumlist(element);
      print("length ${element.length}");
      for (int i=0; i < element.length - 1; i++){
        sum += element[i + 1][1] - element[i][0];
        print("sum $sum");
      }
      
    }
    //score = f(x,c);
    return sum;
  }

  static void sortSumlist(List<List<int>> unsorted){
    print("sorted");
    int n = unsorted.length;
  for (int i = 0; i < n - 1; i++) {
    bool swapped = false;
    for (int j = 0; j < n - i - 1; j++) {
      try{
        if (unsorted[j][0] > unsorted[j + 1][0] ) {
          // Swap numbers
          List<int> temp = unsorted[j];
          unsorted[j] = unsorted[j + 1];
          unsorted[j + 1] = temp;
          swapped = true;
        }
      }
      catch(e){}
    }
    // If no swaps were made, the list is sorted
    if (!swapped) {
      break;
    }
  }
  }

  static int calcdeltaMostFewEvents(List<DayEvent> schema, DateTimeRange spann){
    int score = 0;
    int numDays = spann.duration.inDays;
    int mostEvents = 0;
    int fewestEvents = 1000;
    int counter = 0;
    DateTime firstDay = DateTime.now().add(Duration(days: 1));
    //the delta of the day with the most events compared the the one with the fewest

    for (int i = 0; i < numDays; i++){
      counter = 0;
      for (DayEvent element in schema) {
        print("1 ${element.date.start.day}, 2 ${firstDay.add(Duration(days: i)).day}");
        if(element.date.start.day == firstDay.add(Duration(days: i)).day){
          print("counter $counter");
          counter++;
        }
      }
      if(counter < fewestEvents){
        fewestEvents = counter;
      }
      else if(counter > mostEvents){
        mostEvents = counter;
      }
    }
    score = mostEvents - fewestEvents;
    //score = f(x,c);
    return score;
  }
}
