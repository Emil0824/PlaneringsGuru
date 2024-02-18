import 'package:flutter/material.dart';


class DaySchedule extends StatefulWidget {
  const DaySchedule({Key? key}) : super(key: key);

  @override
  State<DaySchedule> createState() => _DaySchedule();


}


class _DaySchedule extends State<DaySchedule>{

  var dayTasks = [{8, 10,"Kms"},{13, 14,"Try again"}];
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
          left: MediaQuery.of(context).size.width /4,
          right: MediaQuery.of(context).size.width /4,
          
          child: ListView.builder(
            itemCount: dayTasks.length,
            itemBuilder: (context, index)  {
              final start = dayTasks[index].elementAt(0);
              final end = dayTasks[index].elementAt(1);
              final note = dayTasks[index].elementAt(2);
              
            },
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
