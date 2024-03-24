
import 'package:flutter/material.dart';
import 'package:planeringsguru/widgets/MonthSchedule.dart';
import 'package:planeringsguru/widgets/addEvent.dart';

class MonthView extends StatefulWidget {

  @override
  State<MonthView> createState() => _MonthViewState();
}

class _MonthViewState extends State<MonthView> {
  
  
  //callback function to update page
  callback(){
    setState(() {
      
    });
  }


  int currentPageIndex = 2;

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      
        body: MonthSchedule(),
        floatingActionButton: AddEvent(
          callbackFunction: callback,
      ),
        );
    
  }

  /*
    List<DateTime> monthDay;
    DateTime now = DateTime.now();
    DateTime counter = DateTime(now.year,now.month,1);
    while(counter.month == now.month){
      
      monthDay.add(counter);
      counter.add(Duration(days: 1));
    }


  */




}
