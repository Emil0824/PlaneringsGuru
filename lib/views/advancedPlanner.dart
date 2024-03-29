// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:planeringsguru/classes/dayEvent.dart';


class AdvancedPlanner extends StatefulWidget {
  const AdvancedPlanner({super.key});


  @override
  State<AdvancedPlanner> createState() => _AdvancedPlannerState();
}

class _AdvancedPlannerState extends State<AdvancedPlanner> {
  @override
  Widget build(BuildContext context) {
    DateTime _startTime = DateTime.now();
    Duration _duration = Duration(hours: 1, minutes: 15);
    String _title = "Ange titel";
    



    return Scaffold(
      appBar: AppBar(title: Text("Advancerad Planering")),
      
      body: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {           
          return Column(
          children: [
            ListTile(
              title: const Text("Titel"),
              subtitle: TextField(
                autofocus: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  _title = value;
                },
              )
            ),  
            ListTile(
              title: const Text("Start tid"),
              
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
              title: const Text("Längd"),
              subtitle: Text("${_duration.inMinutes} minuter"),
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
            TextButton(
              onPressed: (){
                  DayEvent.addEventFields(_startTime, _duration, _title, false);
                  Navigator.pop(context);
                },
              child: const Text("Skapa")
              )
          ],
        );
        }
      ),
    
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