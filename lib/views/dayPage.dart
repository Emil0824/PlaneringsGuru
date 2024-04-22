


// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:planeringsguru/widgets/addEvent.dart';
import 'package:planeringsguru/widgets/daySchedule.dart';

import 'package:planeringsguru/widgets/dayAppbar.dart';

class DayView extends StatefulWidget {
  const DayView({super.key});

  
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
        appBar: DayAppBar(
          callbackFunction: callback,
          ),
        body: DaySchedule(callback: callback),
        floatingActionButton: AddEvent(
          callbackFunction: callback,
        ),
        
    );
  }
}
