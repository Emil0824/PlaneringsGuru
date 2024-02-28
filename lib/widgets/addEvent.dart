import 'package:flutter/material.dart';
import 'package:planeringsguru/widgets/daySchedule.dart';

class  AddEvent extends StatefulWidget {
  @override
  _AddEventState createState() => _AddEventState();

}


class _AddEventState extends State<AddEvent>{

  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay(hour: (TimeOfDay.now().hour + 1) % 24, minute: TimeOfDay.now().minute);
  String _title = "Ange titel";


  @override
  Widget build(BuildContext context){
    return FloatingActionButton(
        onPressed: () {
          eventPicker();
        },
        tooltip: 'Skapa Event',
        child: const Icon(Icons.add),
      ); 
  }

  Future<void> eventPicker() async {  
    await showDialog(
      context: context, 
      builder: (BuildContext context) {  
        return AlertDialog(
          title: Text("Välj start och slut tid!"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {           
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text("Titel"),
                    subtitle: TextField(
                      autofocus: true,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        _title = value;
                      },
                    )
                  ),
                  ListTile(
                    title: Text("Start tid"),
                    
                    subtitle: Text("${_startTime.hour}:${_startTime.minute}"),
                    onTap: () async{
                      final tid = await timePick(true);
                      if (tid != null) {
                        setState(() {
                          _startTime = tid;
                          if (_startTime.hour > _endTime.hour || (_startTime.hour == _endTime.hour && _startTime.minute > _endTime.minute)){
                            _endTime = TimeOfDay(hour: tid.hour, minute: tid.minute);

                          }
                        });
                      }
                      
                    },
                  ),
                  ListTile(
                    title: Text("Slut tid"),
                    subtitle: Text("${_endTime.hour}:${_endTime.minute}"),
                    onTap: () async{
                      final tid = await timePick(false);
                      if (tid != null) {
                        setState(() {
                          _endTime = tid;
                          
                        });
                      }
                      
                    },
                  ),
                ]
              );
            }
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Avbryt"),
            ),
            TextButton(
              onPressed: (){
                DaySchedule.addEvent(_startTime,_endTime, _title);
                Navigator.of(context).pop();
              }, 
              child: Text("Skapa")
            ),
          ],
        );
      }, 
      
    );
  }

  Future<TimeOfDay?> timePick(bool isStart) async {
    final tid = await showTimePicker(
      context: context, 
      initialTime: isStart ? _startTime : _endTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      }
    );

    return tid;

  }
}