import 'package:flutter/material.dart';
import 'package:planeringsguru/classes/dayEvent.dart';

class  AddEvent extends StatefulWidget {
  @override
  _AddEventState createState() => _AddEventState();

}


class _AddEventState extends State<AddEvent>{

  DateTime _startTime = DateTime.now();
  Duration _duration = Duration(hours: 1, minutes: 15);
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
                      final tid = await showDateTimePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now());
                      if (tid != null) {
                        setState(() {
                          _startTime = tid;
                          }
                        );
                      }
                    
                    },
                  ),
                  ListTile(
                    title: Text("Längd"),
                    subtitle: Text("${_duration.inMinutes} minuits"),
                    onTap: () async{
                      final tid = await showTimePicker(context: context,initialTime: TimeOfDay(hour: 0, minute: 0),
                        initialEntryMode: TimePickerEntryMode.inputOnly,
                        );
                      if (tid != null) {
                        setState(() {
                          _duration = Duration(hours: tid.hour, minutes: tid.minute);
                          
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
                DayEvent.addEvent(_startTime,_duration, _title);
                Navigator.of(context).pop();
              }, 
              child: Text("Skapa")
            ),
          ],
        );
      }, 
      
    );
  }

  Future<DateTime?> showDateTimePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    initialDate ??= DateTime.now();
    firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
    lastDate ??= firstDate.add(const Duration(days: 365 * 200));

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate == null) return null;

    if (!context.mounted) return selectedDate;

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );

    return selectedTime == null
    ? selectedDate
    : DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );
  }


  

  
}