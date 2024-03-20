


import 'package:flutter/material.dart';
import 'package:planeringsguru/widgets/addEvent.dart';
import 'package:planeringsguru/widgets/daySchedule.dart';

class DayView extends StatefulWidget {

  @override
  State<DayView> createState() => _DayViewState();
}

class _DayViewState extends State<DayView> {

  callback(){
    setState(() {
      
    });
  }


  int currentPageIndex = 1;

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        
        body: DaySchedule(),
        floatingActionButton: AddEvent(callbackFunction: callback),
    );
  }
}
