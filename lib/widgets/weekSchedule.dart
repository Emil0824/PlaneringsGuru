import 'package:flutter/material.dart';
import 'package:planeringsguru/classes/schedulePainter.dart';
import 'package:planeringsguru/widgets/Event.dart';
import 'package:planeringsguru/widgets/daySchedule.dart';



class WeekSchedule extends StatelessWidget{
  



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        
        Positioned.fill(
          child: CustomPaint(
            painter: SchedulePainter(isweek: true),
          )
        ),
        Positioned.fill(
          child: Event(
              scheduleData: DaySchedule.getDayTasks(),
          )
        )

      ],
    );
      
    
  }


  
}




