// ignore_for_file: file_names, prefer_const_constructors, no_logic_in_create_state, library_private_types_in_public_api, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:planeringsguru/classes/algotithm.dart';
import 'package:planeringsguru/views/advancedPlanner.dart';


class  AddEvent extends StatefulWidget {
  final Function callbackFunction;

  AddEvent({Key? key, required this.callbackFunction}) : super(key: key);


  @override
  _AddEventState createState() => _AddEventState(
    callbackFunction: callbackFunction,
  );

}


class _AddEventState extends State<AddEvent>{
  final Function callbackFunction;
  

  _AddEventState({required this.callbackFunction});

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
          title: const Text("Välj start och slut tid!"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {           
              return Column(
                mainAxisSize: MainAxisSize.min,
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
                  ),  /*
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
                  ),*/
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
                ]
              );
            }
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Avbryt"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => AdvancedPlanner(),
                  ));
              },
              child: const Text("Advancerad"),
            ),
            TextButton(
              onPressed: (){
                Algorithm.planEvent(_title, _duration);
                callbackFunction();
                Navigator.of(context).pop();
              }, 
              child: const Text("Skapa")
            ),
          ],
        );
      }, 
      
    );
  }

}