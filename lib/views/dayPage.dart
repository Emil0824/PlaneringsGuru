


import 'package:flutter/material.dart';
import 'package:planeringsguru/widgets/addEvent.dart';
import 'package:planeringsguru/widgets/daySchedule.dart';

class DayView extends StatefulWidget {

  @override
  State<DayView> createState() => _DayViewState();
}

class _DayViewState extends State<DayView> {
  int currentPageIndex = 1;

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });

           switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/settings');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/day');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/week');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/month');
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/account');
              break;
          }
        },
        indicatorColor: Color.fromARGB(255, 201, 164, 108),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Inställningar',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today),
            label: 'Dag',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_view_week),
            label: 'Vecka',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month),
            label: 'Månad',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Konto',
          ),
        ],
      ),
        body: DaySchedule(),
        floatingActionButton: AddEvent(),
    );
  }
}
