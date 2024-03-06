import 'package:flutter/material.dart';
import 'package:planeringsguru/classes/schedulePainter.dart';
import 'package:planeringsguru/widgets/Event.dart';
import 'package:planeringsguru/classes/dayEvent.dart';



class DaySchedule extends StatefulWidget {
  const DaySchedule({Key? key}) : super(key: key);

  @override
  State<DaySchedule> createState() => _DaySchedule();


  static addEvent(DateTime start, Duration duration, String title){
    
      _DaySchedule.dayTasks.add(DayEvent(
        start: start, 
        dutration: duration,
        title: title
        ));
        
    
  }

  static getDayTasks(){
    return _DaySchedule.dayTasks;
  }
}



class _DaySchedule extends State<DaySchedule>{

  static List<DayEvent> dayTasks = [DayEvent(start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 13, 0), dutration: Duration(hours:1, minutes: 15), title: "test")];
  var list = [for(var i=8; i<21; i+=1) i];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: SchedulePainter(isweek: false),
          )
        ),
        Positioned.fill(
          child: Event(
              scheduleData: dayTasks,
          )
        )

        
        
      ],
    );
      
      
    
  }

  
}


