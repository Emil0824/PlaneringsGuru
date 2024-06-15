// ignore_for_file: file_names, prefer_const_constructors, no_logic_in_create_state, library_private_types_in_public_api, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
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
  String _tempDuration = "";
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
          title: const Text("Välj Titel och Längd"),
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
                  ),  
                  ListTile(
                    title: Text("Längd"),
                    subtitle: TextField(
                      autofocus: false,
                      textAlign: TextAlign.center,
                      maxLength: 5,
                      onChanged: (value) {
                        _tempDuration = value;
                      },
                    )
                    
                    
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
              child: const Text("Avancerad"),
            ),
            TextButton(
              onPressed: (){
                bool flag = false;
                try {
                  String hour = _tempDuration.substring(0, 2);
                  String minut = _tempDuration.substring(3, 5);
                
                  _duration = new Duration(hours: int.parse(hour), minutes: int.parse(minut));
                  flag = true;
                } catch (e) {
                }
                
                
                if (flag) {
                  Algorithm.planEvent(_title, _duration);
                  callbackFunction();
                  Navigator.of(context).pop();
                }
                else{
                  showDialog(
                    context: context, 
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Fel inmatning på Längd"),
                      );
                    }
                  );
                }
              }, 
              child: const Text("Skapa")
            ),
          ],
        );
      }, 
      
    );
  }

}