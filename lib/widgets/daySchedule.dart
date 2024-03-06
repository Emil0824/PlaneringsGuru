import 'package:flutter/material.dart';
import 'package:planeringsguru/classes/schedulePainter.dart';
import 'package:planeringsguru/widgets/Event.dart';



class DaySchedule extends StatefulWidget {
  const DaySchedule({Key? key}) : super(key: key);

  @override
  State<DaySchedule> createState() => _DaySchedule();


  

}



class _DaySchedule extends State<DaySchedule>{

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
          )
        )

        
        
      ],
    );
      
      
    
  }

  
}


