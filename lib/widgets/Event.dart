import 'package:flutter/material.dart';
import 'package:planeringsguru/classes/dayEvent.dart';


class Event extends StatelessWidget {
  final List<DayEvent> scheduleData;
  Event({required this.scheduleData});
  

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {

        final double maxHeight = constraints.maxHeight;

        final hourHight = maxHeight / 12;
        final minuteHeight = hourHight / 60;


        return Stack(
          children: getPositionedStuff(hourHight, minuteHeight, maxHeight, context)
        );
      }
    );
  }



  List<Widget> getPositionedStuff(hourHight, minuteHeight, maxHeight, context){
    List<Positioned> events = [];


    
    int offset = 1;

    scheduleData.forEach((element) {

      events.add(
        Positioned(
            top:(hourHight * (element.start.hour - 8 )) + (minuteHeight * element.start.minute),
            bottom: (hourHight * (12 - (element.end.hour - 8))) - minuteHeight * element.end.minute,
            right: MediaQuery.of(context).size.width/2 - (50 * offset++),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(10, 10, 100, 120),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                border: Border.all(color: Color.fromRGBO(10, 10, 100, 1)),
              ),
              width: 100,
              
              child: Column(
                children: [
                  Container(
        
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(221, 221, 255, 1),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
                    ),   
                    
                    height: 30,
                    width: 100,
                    child: Center(
                      child: Text(
                        element.title,
                                    
                      ),
                    )
                  ),
                ]
              ),
            )
          ),
      );
    });

    return events;

    
  }
}
