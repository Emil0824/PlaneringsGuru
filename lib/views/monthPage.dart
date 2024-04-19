
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:planeringsguru/widgets/MonthSchedule.dart';
import 'package:planeringsguru/widgets/addEvent.dart';

class MonthView extends StatefulWidget {
  const MonthView({super.key});


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
      
        body: const MonthSchedule(),
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
