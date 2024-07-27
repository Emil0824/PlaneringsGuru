// ignore_for_file: sized_box_for_whitespace, file_names



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:planeringsguru/classes/algotithm.dart';
import 'package:planeringsguru/classes/dayEvent.dart';
import 'package:planeringsguru/classes/schedulePainter.dart';
import 'package:planeringsguru/widgets/Event.dart';





class WeekSchedule extends StatelessWidget{

  final Function callback;
  const WeekSchedule({super.key, required this.callback});

  

  @override
  Widget build(BuildContext context) {

    double size = MediaQuery.sizeOf(context).height * 2;

    double spaceBetween = size / 24;
    double nowOffset = spaceBetween * (TimeOfDay.now().hour) + spaceBetween/60*TimeOfDay.now().minute;

    nowOffset = nowOffset - (MediaQuery.sizeOf(context).height / 4);

    if (nowOffset < 0){
      nowOffset = 0;
    }


    return Stack(
      children: [
        Positioned.fill(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                controller: ScrollController(
                  initialScrollOffset: nowOffset
                  
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                          minHeight: viewportConstraints.maxHeight,
                        ),
                  child: IntrinsicHeight(
                    child: Container(
                      height: size,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CustomPaint(
                              painter: SchedulePainter(isweek: true),
                            )
                          ),
                          Positioned.fill(
                            child: Event(currentPage: "week", callback: callback)
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          ),
        ),
        /*Positioned(
          left: 15,
          bottom: 15,
          child: FloatingActionButton(
            onPressed: () {
              //eventShuffle(context)       
              String saveString = jsonEncode(DayEvent.events);
              Clipboard.setData(ClipboardData(text: saveString));
              print(saveString);
            },
            tooltip: 'Schema val',
            child: const Icon(Icons.menu),
          )
        )*/
      ],
    );
  }

  Future<void> eventShuffle(context) async {
    await showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Shuffla schemat?"),
          actions: [
            Center(
              child: Row(children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  }, 
                  child: Text("Nej")
                ),
                TextButton(
                  onPressed: () {
                    Algorithm.reShuffleSchema(1, 4);
                    Navigator.of(context).pop();
                    callback();
                  }, 
                  child: Text("Ja")
                ),
              ],),
            )
          ],
        );
      },
    );
  }

}




