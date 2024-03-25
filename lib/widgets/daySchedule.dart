// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors_in_immutables, file_names

import 'package:flutter/material.dart';
import 'package:planeringsguru/classes/choosenDay.dart';
import 'package:planeringsguru/classes/schedulePainter.dart';
import 'package:planeringsguru/widgets/Event.dart';



class DaySchedule extends StatefulWidget {

  DaySchedule({Key? key}) : super(key: key);
  
  

  @override
  State<DaySchedule> createState() => _DaySchedule();

}



class _DaySchedule extends State<DaySchedule>{

  var list = [for(var i=8; i<21; i+=1) i];
  DateTime choosenDay = ChoosenDay.choosenDay;

  
  _DaySchedule();

  @override
  Widget build(BuildContext context) {


    double size = MediaQuery.sizeOf(context).height * 2;

    double spaceBetween = size / 24;
    double nowOffset = spaceBetween * (TimeOfDay.now().hour) + spaceBetween/60*TimeOfDay.now().minute;

    nowOffset = nowOffset - (MediaQuery.sizeOf(context).height / 4);

    if (nowOffset < 0){
      nowOffset = 0;
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          controller: ScrollController(
            initialScrollOffset: nowOffset
            
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
            child: IntrinsicHeight(
              child: Container(
                height: size,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: SchedulePainter(isweek: false),
                      )
                    ),
                    Positioned.fill(
                      child: Event(
                        currentPage: "day",
                      )
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
      
      
    
  }

  
}


