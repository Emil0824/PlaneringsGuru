import 'dart:math';

import 'package:flutter/material.dart';
import 'package:planeringsguru/classes/dayEvent.dart';
import 'package:planeringsguru/classes/intTripplet.dart';
import 'package:planeringsguru/classes/userPreferences.dart';
import 'package:planeringsguru/widgets/Event.dart';


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
    List<DayEvent> staticEvents = DayEvent.getEventsInSpann(spann);
    int howMany = 100;
    
    
    List<DayEvent> newSchema = planList([tempDayEvent], spann, staticEvents + looseEvents, howMany, false);     //replan inputed event
    Event.addOptionalEvents(newSchema);
  }

  static reShuffleSchema(int from, int to){
    DateTime now = DateTime.now();
    DateTimeRange spann = DateTimeRange(start: DateTime(now.year, now.month,now.day + from, 0, 0), end: DateTime(now.year, now.month,now.day + to, 0, 0));

    List<DayEvent> looseEvents = DayEvent.getLooseEventAndRemove(spann);
    List<DayEvent> staticEvents = DayEvent.getEventsInSpannAndRemove(spann);
    int howMany = 100;

   
    DayEvent.events += planList(looseEvents, spann, staticEvents, howMany, true);   //replan whole looseschema
  }


  static List<DayEvent> planList(List<DayEvent> looseEvents, DateTimeRange spann, List<DayEvent> staticEvents, int howMany, bool isShuffle){
    List<List<DayEvent>> arrayOfSchemas = [];
    


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
    int spannTime = spann.duration.inMinutes ~/ 5;
    DayEvent randEvent;

    for (var current in staticEvents) {
      nonoValues.addAll(getNoNoValues(current, spann));
    }

    List<List<int>> localNonoValues = [];
    
    for (int i = 0; i < howMany; i++){
      localNonoValues.add(List.from(nonoValues));    
      
    }


    //generate random times
    for (int i = 0; i < howMany; i++){
      arrayOfSchemas.add(List.from(staticEvents));
      
      for (DayEvent current in looseEvents) {
        int durrTime = current.date.duration.inMinutes ~/ 5;
        

        bool okSpot = false;
        while (!okSpot) {
          int startTime = Random().nextInt(spannTime - durrTime);

          List<int> eventValues = [];

          for (int val = startTime; val <= startTime + durrTime; val++){
            eventValues.add(val);
          }

          if (!containsFromListToList(localNonoValues[i], eventValues)){
            okSpot = true;
            //print("startTime: $startTime");
            int day = startTime ~/ 288;
            int hour = (startTime % 288) ~/ 12;
            int minute = ((startTime % 288) % 12) * 5;
            randEvent = DayEvent(start: DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1 + day, hour, minute), duration: current.date.duration, title: current.title, isAuto: true, isOptional: !isShuffle);
            arrayOfSchemas[i].add(randEvent);
            localNonoValues[i].addAll(getNoNoValues(randEvent, spann));
          }   
        }
      }
    }


    //find good schemas from arrayOfSchemas
    /*
    Evenly spread? ie about the same amount of things on every day
    Gaps are not too large?
    Time of day? when stuff is happening
    */
    
    double sumGaps;
    double avgDistanceMidnight;
    double score;
    double bestscore = 0;
    List<DayEvent> bestSchedule = [];

    
    if (isShuffle) {
      bestSchedule = arrayOfSchemas[0];

      for (int i = 0; i < howMany; i++) {
      
        sumGaps = calcavgGaps(arrayOfSchemas[i], spann)[1]; //compactness

        //extract double
        //double deltaMostFewEvents = calcdeltaMostFewEvents(arrayOfSchemas[0], spann); //events per day diff
        avgDistanceMidnight = calcavgDistance2am(localNonoValues[i])[1]; //how close to the middle of the day are things planned

        //print("sumGaps: $sumGaps \n");
        //print("deltaMostFewEvents: $deltaMostFewEvents \n");
        //print("avgDistanceMidnight: $avgDistanceMidnight \n");
        

        /*
        show = {[a,30][b,35][c,45]}
        {d,25}deltaMostFewEvents
        */
        score = sumGaps + avgDistanceMidnight;
        if (score > bestscore){
          bestscore = score;
          bestSchedule = arrayOfSchemas[i];
        }
      }

      bestSchedule;
    }
    else {
      Map<double, DayEvent> bestOnce = {};


      for (int i = 0; i < howMany; i++) {
        sumGaps = calcavgGaps(arrayOfSchemas[i], spann)[1]; //compactness
        //double deltaMostFewEvents = calcdeltaMostFewEvents(arrayOfSchemas[0], spann); //events per day diff
        avgDistanceMidnight = calcavgDistance2am(localNonoValues[i])[1]; //how close to the middle of the day are things planned

        //print("sumGaps: $sumGaps \n");
        //print("deltaMostFewEvents: $deltaMostFewEvents \n");
        //print("avgDistanceMidnight: $avgDistanceMidnight \n");
        

        /*
        show = {[a,30][b,35][c,45]}
        {d,25}deltaMostFewEvents
        */
        score = sumGaps + avgDistanceMidnight;
        
        if (bestOnce.length < 3) {
          bestOnce.addAll({score: arrayOfSchemas[i][arrayOfSchemas[i].length - 1]});
        }
        else {
          double lowestKey = 9999999999;
          for(double key in bestOnce.keys) {
            if (key < lowestKey){
              lowestKey = key;
            }
          }

          if (score > lowestKey){

            bestOnce.remove(lowestKey);
            bestOnce.addAll({score: arrayOfSchemas[i][arrayOfSchemas[i].length - 1]});
          }
        }
      }

      bestSchedule.addAll(bestOnce.values);
    }
    
    return bestSchedule;
    
  }

  static List<int> getNoNoValues(DayEvent event, DateTimeRange spann){
    List<int> nonoValues = [];

    int minuteTime = event.date.start.minute - spann.start.minute;
    int hourTime = event.date.start.hour - spann.start.hour;
    int dayTime = event.date.start.day - spann.start.day;
    int durrTime = event.date.duration.inMinutes ~/ 5;

   

    int startTime = (minuteTime~/5) + (hourTime * 12) + (dayTime * 288);
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

  static List<double> calcavgDistance2am(List<int> occupiedSlots){
    //sum the distance of all events from midnight divided by the number of events
    double totscore = 0;
    double vikt = UserPreferences.workTimeShifter;
    double hourSum = 0;
    double worstTime = 12;
    double worstTimeScore = -5000;
   

    for (int current in occupiedSlots) {
      double temp = (current % 288)/12;
      hourSum += temp;
      //mega nice equation

      
      totscore += (100) / (1 + exp(-1.6 * (temp - 8.3 + vikt)) + exp(1.2 * (temp - 18 + vikt)));


      double timeScore = pow(temp, 2) - 24 * temp + 150;
      if (timeScore > worstTimeScore){
        worstTime = temp;
      }
    }

    double score = totscore / occupiedSlots.length;
    double x = hourSum / occupiedSlots.length;
    
    return [x, score, worstTime];
  }

  static List<double> calcavgGaps(List<DayEvent> schema, DateTimeRange spann){
    double score = 0;
    int numDays = spann.duration.inDays;
    double sum = 0;
    int counter = 0;
    List<IntTripplet> daystartEnd = [];
    DateTime firstDay = DateTime.now().add(const Duration(days: 1));
    //Gaps between events of the same day
    for (int i = 0; i < numDays; i++){
      for (DayEvent element in schema) {
        if (element.date.start.day != element.date.end.day ){
          return [-2000, -2000];
        }
        if(element.date.start.day == firstDay.add(Duration(days: i)).day){
          daystartEnd.add(IntTripplet(day: element.date.start.day, start: element.date.start.hour * 60 + element.date.start.minute, end: element.date.end.hour * 60 + element.date.end.minute));
        }
      }
    }
    
    sortSumlist(daystartEnd);
    for (int i=0; i < daystartEnd.length - 1; i++){
      if (daystartEnd[i].day == daystartEnd[i+1].day){
        sum +=daystartEnd[i+1].start - daystartEnd[i].end;
        counter++;
      } 
    }

    double alpha = UserPreferences.breakTime; // collect weighted from personal class
    if (counter == 0){
      return[0, 0];
      }
    sum /= counter;

    if (sum <= alpha){
      score = exp((1 / alpha) * log(100) * sum);
    }
    else{
      score = (100) / (1 + exp(0.05 * (sum - (100 + alpha))));
    }
    
    return [sum, score];
  }


  static void sortSumlist(List<IntTripplet> unsorted){
    int n = unsorted.length;
    for (int i = 0; i < n - 1; i++) {
      bool swapped = false;
      for (int j = 0; j < n - i - 1; j++) {
        try{
          if (unsorted[j].day >= unsorted[j + 1].day && unsorted[j].start > unsorted[j + 1].start) {
            // Swap numbers
            IntTripplet temp = unsorted[j];
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

//TODO
  static List<double> calcdeltaMostFewEvents(List<DayEvent> schema, DateTimeRange spann){
    double score = 0;
    double x = 0;
    int numDays = spann.duration.inDays;
    double mostEvents = 0;
    double fewestEvents = 1000;
    double counter = 0;
    DateTime firstDay = DateTime.now().add(const Duration(days: 1));
    //the delta of the day with the most events compared the the one with the fewest

    for (int i = 0; i < numDays; i++){
      counter = 0;
      for (DayEvent element in schema) {
        if(element.date.start.day == firstDay.add(Duration(days: i)).day){
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
    x = mostEvents - fewestEvents;

    //score = f(x,c);
    return [x,score];
  }
}
