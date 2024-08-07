// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:planeringsguru/classes/algotithm.dart';
import 'package:planeringsguru/classes/dayEvent.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';


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
    bool _isLoose = false;
    DateTime _startDate = DateTime.now();
    DateTime _endDate = DateTime.now().add(Duration(days: 4));
    



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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Löst planerat:"),
                Checkbox(
                  value: _isLoose,
                  checkColor: Colors.black,
                  activeColor: Colors.amber,
                  onChanged: (bool? value){
                    setState(() {
                      _isLoose = value!;
                    });
                  },
                ),
              ],
            ),
            if (_isLoose) Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    child: ListTile(
                      title: const Text("Första Datum"),

                      subtitle: Text("${_startDate.day}/${_startDate.month}"),
                      onTap: () async{
                          final tid = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate:  DateTime.now().subtract(const Duration(days: 365 * 100)),
                          lastDate:  DateTime.now().add(const Duration(days: 365 * 100)),
                          
                        );
                        if (tid != null) {
                          setState(() {
                            _startDate = tid;
                            }
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: ListTile(
                      title: const Text("Sista Datum"),
                      subtitle: Text("${_endDate.day}/${_endDate.month}"),
                      onTap: () async{
                          final tid = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate:  DateTime.now().subtract(const Duration(days: 365 * 100)),
                          lastDate:  DateTime.now().add(const Duration(days: 365 * 200)),
                        );
                        if (tid != null) {
                          setState(() {
                            _endDate = tid;
                            }
                          );
                        }
                      },
                    ),
                  ),
                ],
              ) else ListTile(
                title: const Text("Start tid"),
                
                subtitle: Text("${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}"),
                onTap: () async{
                  final tid = await showOmniDateTimePicker(
                    context: context,
                    is24HourMode: true,
                    isForce2Digits: true,
                    firstDate: DateTime.now(),
                    
                  );
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
                final tid = await showTimePicker(context: context,initialTime: TimeOfDay(hour: 1, minute: 15),
                        initialEntryMode: TimePickerEntryMode.dialOnly,
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
                  if(_isLoose){
                    Algorithm.planSpannedEvent(_title, _duration, DateTimeRange(start: _startDate, end: _endDate));
                  }
                  else {
                    DayEvent.addEventFields(_startTime, _duration, _title, _isLoose);
                    }
                  
                  int nCount = 0;
                  Navigator.of(context).popUntil((_) => nCount++ >= 2);
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