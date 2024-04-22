// ignore_for_file: non_constant_identifier_names, avoid_function_literals_in_foreach_calls, prefer_typing_uninitialized_variables, file_names


import 'package:flutter/material.dart';
import 'package:planeringsguru/classes/choosenDay.dart';
import 'package:planeringsguru/classes/dayEvent.dart';
import 'package:planeringsguru/classes/globalDesign.dart';
import 'package:planeringsguru/classes/userPreferences.dart';

class Event extends StatefulWidget {
  final currentPage;
  final Function callback;
  Event({super.key, required this.currentPage, required this.callback});

  static List<DayEvent> currentOptionals = [];

  static addOptionalEvents(List<DayEvent> newEvents){
    currentOptionals = newEvents;
  }

  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {
  List<DayEvent> scheduleData = DayEvent.getEvents();

  @override
  Widget build(BuildContext context) {
    scheduleData = DayEvent.getEvents();
    scheduleData += Event.currentOptionals;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {

        final double maxWidth = constraints.maxWidth;

        final hourHight = constraints.maxHeight / 24;
        final minuteHeight = hourHight / 60;


        if (widget.currentPage == "week"){
          return Stack(
            children: getWeekPositions(hourHight, minuteHeight, maxWidth, context)
          );
        }
        else if (widget.currentPage == "day"){
          return Stack(
            children: getPositionedStuff(hourHight, minuteHeight, maxWidth, context, ChoosenDay.choosenDay, -1)
          );
        }


        return const Text("error");
      }
    );
  }

  List<Positioned> getWeekPositions(hourHight, minuteHeight, maxWidth, context){
    int currentDayofWeek = ChoosenDay.choosenDay.weekday;

    
    List<Positioned> events = [];


    for (int i = 0; i <= 7 - currentDayofWeek; i++){
      
      events += (getPositionedStuff(hourHight,minuteHeight,maxWidth,context, ChoosenDay.choosenDay.add(Duration(days: i)), ChoosenDay.choosenDay.add(Duration(days: i)).weekday.toDouble()));

    }

    for (int i = 1; i < currentDayofWeek; i++){
      
      events += (getPositionedStuff(hourHight,minuteHeight,maxWidth,context, ChoosenDay.choosenDay.subtract(Duration(days: i)), ChoosenDay.choosenDay.subtract(Duration(days: i)).weekday.toDouble()));
    }
  
    return events;
    
  }

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.lock_open);
      }
      return const Icon(Icons.lock);
    },
  );

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

        double totHeight = minuteHeight * element.date.duration.inMinutes;

        Color eventC = GlobalDesign.event;

        if (element.isAuto){
          eventC = GlobalDesign.looseEvent;
        }

        events.add(
        Positioned(
            top:(hourHight * (element.date.start.hour)) + (minuteHeight * element.date.start.minute),
            height: totHeight,
            left: totalOffset,
            width: totalWidth,
            child: GestureDetector(
              onTap: () {
                if (element.isOptional){
                  element.isOptional = false;
                  DayEvent.addEvent(element);
                  Event.currentOptionals = [];
                  UserPreferences.weighAdjust(element);
                  widget.callback();
                }
                else{
                  showEventPopup(context, element);
                }
              },
              
              child: Container(
                
                
            
                
                decoration: BoxDecoration(
                  color: element.isOptional? Colors.green : eventC,
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  border: Border.all(color: GlobalDesign.eventBorder),
                ),
                width: 100,
                
                child: Column(
                  children: checkHeight(totHeight, element.title)
                ),
              ),
            )
          ),
        );
     }

      
    });

    return events;

    
  }

  List<Container> checkHeight(height, title) {
    if (height > 50) {
      
      return [
        Container(
          decoration: BoxDecoration(
            color: GlobalDesign.eventBox,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(5.0)),
          ),
          height: 30,
          width: 100,
          child: Center(
            child: Text(
              CheckText(title),
            ),
          )
        )
      ];
    }
    else{
      return [];
    }
  }

  String CheckText(String title){
    String newTitle;

    if(widget.currentPage == "week" && title.length > 4){
      newTitle = "${title.substring(0, 4)}..";
    }
    else if(widget.currentPage == "day" && title.length > 8){
      newTitle = "${title.substring(0, 8)}..";
    }
    else{
      newTitle = title;
    }

    return newTitle;
  }

//"${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}")
  Future<void> showEventPopup(context, DayEvent element) async {
  await showDialog(
    context: context, 
    builder: (BuildContext context) {
      return AlertDialog(
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey, // Choose your border color
                      width: 1.0, // Adjust the border width
                    ),
                    borderRadius: BorderRadius.circular(10.0), // Adjust border radius as needed
                  ),
                  child: ListTile(
                    title: Row(
                      children: [
                        Text(
                          'Titel:'
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            initialValue: element.title,
                            textAlign: TextAlign.end,
                            decoration: InputDecoration(
                              //border: OutlineInputBorder(),
                              
                            ),
                            onChanged: (value) {
                                element.title = value;
                            },
                          ),
                        )
                      ],
                    )
                    
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey, // Choose your border color
                      width: 1.0, // Adjust the border width
                    ),
                    borderRadius: BorderRadius.circular(10.0), // Adjust border radius as needed
                    
                  ),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Dag: "),
                        
                        OutlinedButton(
                          onPressed: () async{
                            final dag = await showDatePicker(
                              context: context, 
                              initialDate: element.date.start, 
                              firstDate: DateTime.now(), 
                              lastDate: DateTime.now().add(Duration(days: 365))
                            );
                            
                          }, 
                          child: Text("${element.date.start.day}/${element.date.start.month} - ${element.date.start.year}"),
                        ),
                        
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey, // Choose your border color
                      width: 1.0, // Adjust the border width
                    ),
                    borderRadius: BorderRadius.circular(10.0), // Adjust border radius as needed
                    
                  ),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        
                        OutlinedButton(
                          onPressed: () {}, 
                          child: Text("${element.date.start.hour.toString().padLeft(2, '0')}:${element.date.start.minute.toString().padLeft(2, '0')}")
                        ),
                        

                        const Text(" - "),
                        
                        
                        OutlinedButton(
                          onPressed: () {}, 
                          child: Text("${element.date.end.hour.toString().padLeft(2, '0')}:${element.date.end.minute.toString().padLeft(2, '0')}"),
                        ),
                        
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10,),

                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey, // Choose your border color
                      width: 1.0, // Adjust the border width
                    ),
                    borderRadius: BorderRadius.circular(10.0), // Adjust border radius as needed
                    
                  ),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Är flytlig:"),
                        Switch(
                          value: element.isAuto, 
                          thumbIcon: thumbIcon,

                          onChanged: (value) {
                            setState(() {
                              element.isAuto = value;
                              widget.callback();   //de är såhär man gör state callback
                            });
                            
                          }
                        )
                      ],
                    )
                    ),
                  ),
                
                //Text(
                //  "${element.title} \nStart tid: ${element.date.start.hour.toString().padLeft(2, '0')}:${element.date.start.minute.toString().padLeft(2, '0')} \nSlut tid: ${element.date.end.hour.toString().padLeft(2, '0')}:${element.date.end.minute.toString().padLeft(2, '0')}"
                //  ,style: TextStyle(
                //    fontSize: 16
                //  ),
                //),
                //IconButton(onPressed: onPressed, icon: icon),
                SizedBox(height: 10,),
                
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey, // Choose your border color
                      width: 1.0, // Adjust the border width
                    ),
                    borderRadius: BorderRadius.circular(10.0), // Adjust border radius as needed
                    
                    ),
                    child: ListTile(
                      title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Ta bort:"),
                        OutlinedButton(
                          onPressed: () {
                            setState (() {
                              DayEvent.removeEvent(element);
                              Navigator.of(context).pop();
                              widget.callback();
                            });
                            
                          }, 
                          child: Icon(Icons.close),
                        ),
                      ],
                    )
                    )
                  )
              ],
            );
          }
        )
        
      );
    });
  }
}



