import 'package:flutter/material.dart';
import 'package:planeringsguru/widgets/Event.dart';
import 'package:planeringsguru/classes/dayEvent.dart';


class DaySchedule extends StatefulWidget {
  const DaySchedule({Key? key}) : super(key: key);

  @override
  State<DaySchedule> createState() => _DaySchedule();


  static addEvent(TimeOfDay start, TimeOfDay end, String title){
    
      _DaySchedule.dayTasks.add(DayEvent(
        start: start, 
        end: end, 
        title: title
        ));
        
    
  }
}



class _DaySchedule extends State<DaySchedule>{

  static List<DayEvent> dayTasks = [DayEvent(start: TimeOfDay(hour: 10, minute: 00), end: TimeOfDay(hour: 14, minute: 00), title: "test")];
  var list = [for(var i=8; i<21; i+=1) i];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: SchedulePainter(),
          )
        ),
        Positioned.fill(
          child: Event(
              scheduleData: dayTasks,
          )
        )

        /*
            itemCount: dayTasks.length,
            itemBuilder: (context, index)  {
              final start = dayTasks[index].start.hour;
              final end = dayTasks[index].end.hour;
              final note = dayTasks[index].title;
              
           */
           
        
      ],
    );
      
      
    
  }

  
}


//Custom painter to make the background for dayView
class SchedulePainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {

    //create a brush
    final Paint paint = Paint()
    ..color = Colors.grey[400]!
    ..strokeWidth = 1.0;

    //height for each space between
    final double spaceBetween = size.height / 12;

    
    
    
    //drawing horizontal lines for each hour
    for (int i = 1; i <= 12; i++) {
      final y = i * spaceBetween;



      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);

      

      TextPainter tp = TextPainter(
        text: TextSpan(
          text: '${(i + 8).toString().padLeft(2, '0')}:00',
          style: TextStyle(color: Colors.grey[500]),
        ),
        textDirection: TextDirection.ltr
      );

      tp.layout(
        minWidth: 0,
        maxWidth: size.width,
      );

      tp.paint(canvas, Offset(10, y - tp.height));

    }


   
  }


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}

