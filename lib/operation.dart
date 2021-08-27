import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import "package:intl/intl.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class LocalDatabase {
  List datalist = [];
  var data;
  final dio = Dio();
  final domain = '10.0.2.2';

  Future<List> getData(int index) async {
    final response = await dio.get(
      "http://$domain:8000/todos/list/$index",
    );
    datalist = response.data;
    return datalist;
  }

  Future<Map<String, dynamic>> retrieveData(var index) async {
    final responce = await dio.get(
      "http://$domain:8000/todos/retrieve/$index",
    );
    data = responce.data as Map<String, dynamic>;
    return data;
  }

  Future listlength() async {
    final response = await dio.get(
      "http://$domain:8000/todos/list/len",
    );
    data = response.data["listlen"];
    return data;
  }

  Future postData(String title, String date, String image) async {
    final response = await dio.post(
      "http://$domain:8000/todos/",
      data: {
        "title": title,
        "date": date,
        "donebool": false,
        "image": image,
      },
    );
    data = response.data;
  }

  Future updateData(var index, String title, String date, String image) async {
    final response = await dio.patch(
      "http://$domain:8000/todos/$index",
      data: {"title": title, "date": date, "image": image},
    );
    data = response.data;
  }

  Future boolchange(int pk, bool boolvalue) async {
    final response = await dio.patch(
      "http://$domain:8000/todos/$pk",
      data: {
        "donebool": boolvalue,
      },
    );
    data = response.data;
  }

  Future deleteData(int pk) async {
    final responce = await dio.delete(
      "http://$domain:8000/todos/$pk",
    );
    data = responce.data;
  }
}

class Notificationoperation {
  static const int interval = -1;

  void notification() async {
    tz.initializeTimeZones();
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    bool notificationbool = preferences.getBool("notificationbool") ?? true;
    if (notificationbool == true) {
      int targetlength = await LocalDatabase().listlength();
      List notificationtarget = await LocalDatabase().getData(0);
      int index = targetlength;
      if (notificationtarget.length != targetlength) {
        final datetimeformat = DateFormat("y-M-d HH:mm");
        final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
            FlutterLocalNotificationsPlugin();
        flutterLocalNotificationsPlugin.initialize(InitializationSettings(
            android: AndroidInitializationSettings("app_icon"),
            iOS: IOSInitializationSettings()));
        while (index < notificationtarget.length) {
          DateTime deadline = datetimeformat
              .parseStrict(
                  "${notificationtarget[index]['date']} ${notificationtarget[index]['time']}")
              .add(Duration(minutes: interval));
          DateTime now = DateTime.now();
          int dif = deadline.difference(now).inSeconds;
          if (dif <= (-interval) * 60) {
            dif = 1;
          }
          flutterLocalNotificationsPlugin.cancel(index);
          await flutterLocalNotificationsPlugin.zonedSchedule(
            index,
            "〆切が迫っています。",
            "${notificationtarget[index]['title']}",
            tz.TZDateTime.from(DateTime.now(), tz.local)
                .add(Duration(seconds: dif)),
            NotificationDetails(
              android: AndroidNotificationDetails('your channel id',
                  'your channel name', 'your channel description',
                  importance: Importance.max, priority: Priority.high),
              iOS: IOSNotificationDetails(),
            ),
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            androidAllowWhileIdle: true,
          );
          index++;
        }
      }
    }
  }
}
