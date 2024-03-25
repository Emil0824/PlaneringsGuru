
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planeringsguru/classes/choosenDay.dart';

class DayAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function callbackFunction;
  

  const DayAppBar({Key? key, required this.callbackFunction}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    DateTime displayDay = ChoosenDay.choosenDay;

    String month = DateFormat.MMM().format(displayDay);
    int day = displayDay.day;
    return SafeArea(
        left: false,
        right: false,
        child: Stack(children: [
          
          Positioned.fill(
            top: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              IconButton(
                onPressed: () => {
                  ChoosenDay.change(DateTime(displayDay.year, displayDay.month, displayDay.day).subtract(const Duration(days: 1))),
                  callbackFunction()
                }, 
                icon: const Icon(Icons.arrow_left)
              ),
              TextButton(onPressed: null, child: Text("$month $day")),
              IconButton(
                onPressed: () => { 
                  ChoosenDay.change(DateTime(displayDay.year, displayDay.month, displayDay.day).add(const Duration(days: 1))),
                  callbackFunction()
                }, 
                icon: const Icon(Icons.arrow_right)
                )
              ]
              
            ),
          )
        ]));
  }
  
  @override
  Size get preferredSize => const Size(double.maxFinite, 80);
}
