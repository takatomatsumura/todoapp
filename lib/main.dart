import 'package:flutter/material.dart';
import 'package:todoapp/operation.dart';
import 'package:todoapp/detail.dart';
import 'package:todoapp/settings.dart';
import 'package:todoapp/form.dart';
import 'package:todoapp/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Notificationoperation().notification();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'To do',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/home',
        routes: {
          '/home': (context) => MyHomePage(
                title: 'flutter home',
              ),
          '/form': (context) => FormPage(),
          '/detail': (context) => DetailPage(),
          '/setting': (context) => SettingPage(),
        });
  }
}
