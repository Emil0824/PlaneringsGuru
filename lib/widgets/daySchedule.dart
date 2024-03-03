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

    //Draws the line for the current time
    final double nowOffset = spaceBetween * (TimeOfDay.now().hour - 8) + spaceBetween/60*TimeOfDay.now().minute;
    canvas.drawLine(Offset(0, nowOffset), Offset(size.width, nowOffset), Paint()
      ..color = Colors.red[400]!
      ..strokeWidth = 1.0
    );


    //writes the current time above the line
    TextPainter tpain = TextPainter(text:
     TextSpan(
      text: "${TimeOfDay.now().hour.toString().padLeft(2, '0')}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}", 
      style: TextStyle(color: Colors.red[500],)
      ),
      textDirection: TextDirection.ltr
    );
    
    tpain.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    tpain.paint(canvas, Offset(size.width - tpain.width- 10, nowOffset - tpain.height));
    
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

