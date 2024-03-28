
// ignore_for_file: sized_box_for_whitespace, file_names

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:planeringsguru/classes/choosenDay.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function callbackFunction;


  const CustomAppBar({Key? key, required this.callbackFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime displayDay = ChoosenDay.choosenDay;
    final int week = weekNumber(displayDay);
    return SafeArea(
        left: false,
        right: false,
      
        child: Stack(children: [
          
          
          Positioned.fill(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                  IconButton(
                    onPressed: () => {
                      ChoosenDay.change(displayDay.subtract(const Duration(days: 7))),
                      callbackFunction()
                    }, 
                    icon: const Icon(Icons.arrow_left)
                  ),
                  Text("v$week", textScaleFactor: 1.3),
                  IconButton(
                    onPressed: () => { 
                      ChoosenDay.change(displayDay.add(const Duration(days: 7))),
                      callbackFunction()
                    }, 
                    icon: const Icon(Icons.arrow_right)
                    )
                  ]
                  
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: getDaysAndStuff(context),
                  
                ),
              ],
            ),
          ),
          

        ]));
  }

  @override
  Size get preferredSize => const Size(double.maxFinite, 100);

  int numOfWeeks(int year) {
    DateTime dec28 = DateTime(year, 12, 28);
    int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }

  /// Calculates week number from a date as per https://en.wikipedia.org/wiki/ISO_week_date#Calculation
  int weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    int woy = ((dayOfYear - date.weekday + 10) / 7).floor();
    if (woy < 1) {
      woy = numOfWeeks(date.year - 1);
    } else if (woy > numOfWeeks(date.year)) {
      woy = 1;
    }
    return woy;
  }

  List<int> getDateList(){
    int currentDayofWeek = ChoosenDay.choosenDay.weekday;
    List<int> days = List<int>.filled(7,0, growable: true);
    


    for (int i = 0; i <= 7 - currentDayofWeek; i++){
      days[currentDayofWeek + i-1] = ChoosenDay.choosenDay.add(Duration(days: i)).day;
    }

    for (int i = 1; i < currentDayofWeek; i++){
      
      days[currentDayofWeek - i - 1] = ChoosenDay.choosenDay.subtract(Duration(days: i)).day;
      
    }
  
    return days;
    
  }


  
  List<Container> getDaysAndStuff(context){
    DateTime displayDay = ChoosenDay.choosenDay;

    List<Container> weekList= [
      Container(
        width: MediaQuery.of(context).size.width / 8,
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(DateFormat.MMM().format(displayDay), textScaleFactor: 1.3),

          ]
        )
      )
    ];

    List<int> days = getDateList();
    
    List<String> weekDays = ["M","T","O","T","F","L","S"];

    for (int i = 0; i < 7; i++){

      Container temp = Container(
        width: MediaQuery.of(context).size.width / 8,
        child:Column(
        
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(days[i].toString(), textScaleFactor: 1.3),
            Text(weekDays[i], textScaleFactor: 1.3),
          ],
        )
      );

      weekList.add(temp);
    }

    return weekList;
  }
}
