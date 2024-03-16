import 'package:flutter/material.dart';
import 'package:planeringsguru/classes/dayEvent.dart';


class Event extends StatelessWidget {
  final List<DayEvent> scheduleData = DayEvent.events;
  Event();
  

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {

        final double maxWidth = constraints.maxWidth;

        final hourHight = constraints.maxHeight / 12;
        final minuteHeight = hourHight / 60;


        if (ModalRoute.of(context)?.settings.name == "/week"){
          return Stack(
            children: getWeekPositions(hourHight, minuteHeight, maxWidth, context)
          );
        }
        else if (ModalRoute.of(context)?.settings.name == "/day"){
          return Stack(
            children: getPositionedStuff(hourHight, minuteHeight, maxWidth, context, DateTime.now(), -1)
          );
        }


        return Text("error");
      }
    );
  }


  List<Positioned> getWeekPositions(hourHight, minuteHeight, maxWidth, context){
    int currentDayofWeek = DateTime.now().weekday;
    List<Positioned> events = [];


    for (int i = 0; i < 7 - currentDayofWeek; i++){
      
      events += (getPositionedStuff(hourHight,minuteHeight,maxWidth,context, DateTime.now().add(Duration(days: i)), DateTime.now().add(Duration(days: i)).weekday.toDouble()));
    }

    for (int i = 1; i < currentDayofWeek; i++){
      
      events += (getPositionedStuff(hourHight,minuteHeight,maxWidth,context, DateTime.now().subtract(Duration(days: i)), DateTime.now().add(Duration(days: i)).weekday.toDouble()));

    }
  
    return events;
    
  }


  
  

  List<Positioned> getPositionedStuff(hourHight, minuteHeight, maxWidth, context, DateTime today, double offset){
    
    List<Positioned> events = [];
    double totalOffset = offset * maxWidth/8 + maxWidth/(9*8*2);
    double totalWidth = maxWidth/9;

    if(offset == -1){
      totalOffset = maxWidth/2 - 50;
      totalWidth = 100 ;
    }

    scheduleData.forEach((element) {

      if(element.date.start.day == today.day && element.date.start.month == today.month && element.date.start.year == today.year){
        events.add(
        Positioned(
            top:(hourHight * (element.date.start.hour - 8 )) + (minuteHeight * element.date.start.minute),
            height: minuteHeight * element.date.duration.inMinutes,
            left: totalOffset,
            width: totalWidth,
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(10, 10, 100, 120),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                border: Border.all(color: Color.fromRGBO(10, 10, 100, 1)),  //UCfix
              ),
              width: 100,
              
              child: Column(
                children: [
                  Container(
        
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(221, 221, 255, 1),  //UCfix
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
     }

      
    });

    return events;

    
  }
}
