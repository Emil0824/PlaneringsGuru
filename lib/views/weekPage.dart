// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:planeringsguru/widgets/addEvent.dart';
import 'package:planeringsguru/widgets/weekAppbar.dart';
import 'package:planeringsguru/widgets/weekSchedule.dart';

class WeekView extends StatefulWidget {
  const WeekView({super.key});


  @override
  State<WeekView> createState() => _WeekViewState();
}

class _WeekViewState extends State<WeekView> {

  //callback function to update page
  callback(){
    setState(() {
      
    });
  }


  int currentPageIndex = 2;

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      
        body: WeekSchedule(),
        floatingActionButton: AddEvent(
          callbackFunction: callback,
      ),
        appBar: CustomAppBar(),
        );
    
  }
}
