import 'package:flutter/material.dart';
import 'package:planeringsguru/classes/globalDesign.dart';



//Custom painter to make the background for dayView

class SchedulePainter extends CustomPainter{
  final bool isweek;
  SchedulePainter({required this.isweek});


  @override
  void paint(Canvas canvas, Size size) {

    //create a brush
    final Paint paint = Paint()
    ..color = Colors.grey[400]!   //UCfix
    ..strokeWidth = 1.0;

    //height for each space between
    final double spaceBetween = size.height / 12;

    //Draws the line for the current time
    final double nowOffset = spaceBetween * (TimeOfDay.now().hour - 8) + spaceBetween/60*TimeOfDay.now().minute;
    canvas.drawLine(Offset(0, nowOffset), Offset(size.width, nowOffset), Paint()
      ..color = GlobalDesign.timeLine
      ..strokeWidth = 1.0
    );


    //writes the current time above the line
    TextPainter tpain = TextPainter(text:
     TextSpan(
      text: "${TimeOfDay.now().hour.toString().padLeft(2, '0')}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}", 
      style: TextStyle(color: GlobalDesign.timeLine,)
      ),
      textDirection: TextDirection.ltr
    );
    
    tpain.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    //tpain.paint(canvas, Offset(size.width - tpain.width- 10, nowOffset - tpain.height));         //Looks really nice on day shit on week
    
    //drawing horizontal lines for each hour
    for (int i = 1; i <= 12; i++) {
      final y = i * spaceBetween;



      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);

      

      TextPainter tp = TextPainter(
        text: TextSpan(
          text: '${(i + 8).toString().padLeft(2, '0')}:00',
          style: TextStyle(color: GlobalDesign.lines),
        ),
        textDirection: TextDirection.ltr
      );

      tp.layout(
        minWidth: 0,
        maxWidth: size.width,
      );

      tp.paint(canvas, Offset(8, y - tp.height));

    }


    //draw horizontal for week schedule
    if(isweek){
      for (int i = 1; i <= 7; i++){
        final xChange = size.width/8 * i;
        canvas.drawLine(Offset(xChange, 0), Offset(xChange, size.height), paint);

      }

      canvas.drawLine(Offset(0, 0), Offset(size.width, 0), paint);
    }

   
  }


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

