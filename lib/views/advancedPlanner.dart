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
    DateTime? _startTime = null;
    Duration _duration = Duration(hours: 1, minutes: 15);
    String _title = "Ange titel";
    bool _isLoose = false;
    DateTime? _startDate = null;
    DateTime? _endDate = null;
    bool isError = false;
    



    return Scaffold(
      appBar: AppBar(title: Text("Planering")),
      
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      child: ListTile(
                        title: const Text("Längd"),
                        subtitle: Text("${_duration.inMinutes} minuter"),
                        onTap: () async {
                          final tid = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(hour: 0, minute: 0),
                            initialEntryMode: TimePickerEntryMode.inputOnly,
                          );
                          if (tid != null) {
                            setState(() {
                              _duration =
                                  Duration(hours: tid.hour, minutes: tid.minute);
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isError ? Colors.red : Colors.transparent,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(4.0), // Optional, for rounded corners
                        ),
                        child: ListTile(
                          title: const Text("Fast tid & dag"),
                          subtitle: getFastSubtitle(_startTime),
                          onTap: () async {
                            final tid = await showOmniDateTimePicker(
                              context: context,
                              is24HourMode: true,
                              isForce2Digits: true,
                              firstDate: DateTime.now(),
                            );
                            if (tid != null) {
                              setState(() {
                                _startTime = tid;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isError ? Colors.red : Colors.transparent,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(4.0), // Optional, for rounded corners
                      ),
                      child: ListTile(
                        title: const Text("Första Datum"),
                    
                        subtitle: getDateSubtitle(_startDate),
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
                  ),
                  SizedBox(
                    width: 150,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isError ? Colors.red : Colors.transparent,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(4.0), // Optional, for rounded corners
                      ),
                      child: ListTile(
                        title: const Text("Sista Datum"),
                        subtitle: getDateSubtitle(_endDate),
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
                  ),
                ],
              ),
              
    
            TextButton(
              onPressed: (){
                  //bestäm om den e loose
                  


                  if((_startTime != null && (_startDate !=null || _endDate!=null)) || ((_startDate ==null || _endDate ==null) && _startTime == null)|| (_startTime == null && _startDate ==null && _endDate==null)){
                    setState(() {
                      _startTime = null;
                      _endDate = null;
                      _startDate = null;
                      //Error
                      print("errororoororoororo");
                      isError = true;
                      
                    });
                  }
                  else if(_startDate !=null && _endDate !=null){
                    Algorithm.planSpannedEvent(_title, _duration, DateTimeRange(start: _startDate!, end: _endDate!));
                    Navigator.pop(context);
                  }
                  else{
                    DayEvent.addEventFields(_startTime!, _duration, _title, false);
                    Navigator.pop(context);
                  }
                  
                  
                },
              child: const Text("Skapa")
              )
          ],
        );
        }
      ),
    
    );
  }

  getDateSubtitle(_time){
    if (_time == null){
      return Text("inte vald");
    }
    else {
      return Text("${_time.day}/${_time.month}");
    }
  }

  getFastSubtitle(_startTime){
    if (_startTime == null) {
      return Text("inte vald");
    }
    else {
      
      return Text("${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')} - ${_startTime.day.toString()}/${_startTime.month.toString()}");
    }
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