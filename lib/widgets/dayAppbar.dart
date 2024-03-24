
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:planeringsguru/classes/choosenDay.dart';

class DayAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function callbackFunction;
  

  const DayAppBar({Key? key, required this.callbackFunction}) : super(key: key);
  
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
                  ChoosenDay.change(DateTime(displayDay.year, displayDay.month, displayDay.day).subtract(Duration(days: 1))),
                  callbackFunction()
                }, 
                icon: Icon(Icons.arrow_left)
              ),
              TextButton(onPressed: null, child: Text("$month $day")),
              IconButton(
                onPressed: () => { 
                  ChoosenDay.change(DateTime(displayDay.year, displayDay.month, displayDay.day).add(Duration(days: 1))),
                  callbackFunction()
                }, 
                icon: Icon(Icons.arrow_right)
                )
              ]
              
            ),
          )
        ]));
  }
  
  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size(double.maxFinite, 80);
}
