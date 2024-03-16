import 'package:flutter/material.dart';
import 'package:planeringsguru/views/advancedPlanner.dart';
import 'package:planeringsguru/views/dayPage.dart';
import 'package:planeringsguru/views/weekPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calener Mannen',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),  //UCfix
        useMaterial3: true,
      ),
      initialRoute: "/day",
      routes: {
        //'/settings': (context) => SettingsPage(),
        '/day': (context) => DayView(),
        '/week': (context) => WeekView(),
        //'/month': (context) => MonthPage(),
        //'/account': (context) => AccountPage(),
        '/advancedPlan':(context) => AdvancedPlanner(),
      },
      //home: const MyHomePage(title: 'Dags Vy'),
    );
  }
}

