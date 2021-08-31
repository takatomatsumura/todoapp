import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class DrfDatabase {
  List datalist = [];
  var data;
  // final domain = '10.0.2.2:8000';
  final domain = '18.180.75.44';

  Future<List> getData(int index) async {
    final dio = Dio();
    final response = await dio.get(
      'http://$domain/todos/list/$index',
    );
    datalist = response.data;
    return datalist;
  }

  // ignore: type_annotate_public_apis
  Future<Map<String, dynamic>> retrieveData(var index) async {
    final dio = Dio();
    final responce = await dio.get(
      'http://$domain/todos/retrieve/$index',
    );
    data = responce.data as Map<String, dynamic>;
    return data;
  }

  Future listlength() async {
    final dio = Dio();
    final response = await dio.get(
      'http://$domain/todos/list/len',
    );
    data = response.data['listlen'];
    return data;
  }

  Future postData(String title, String date, String image) async {
    final dio = Dio();
    final response = await dio.post(
      'http://$domain/todos/create',
      data: {
        'title': title,
        'date': date,
        'donebool': false,
        'image': image,
      },
    );
    data = response.data;
  }

  // ignore: type_annotate_public_apis
  Future updateData(var index, String title, String date, String image) async {
    final dio = Dio();
    final response = await dio.patch(
      'http://$domain/todos/update/$index',
      data: {'title': title, 'date': date, 'image': image},
    );
    data = response.data;
  }

  Future boolchange(int pk, {required bool boolvalue}) async {
    final dio = Dio();
    final response = await dio.patch(
      'http://$domain/todos/update/$pk',
      data: {
        'donebool': boolvalue,
      },
    );
    data = response.data;
  }

  Future deleteData(int pk) async {
    final dio = Dio();
    final responce = await dio.delete(
      'http://$domain/todos/delete/$pk',
    );
    data = responce.data;
  }
}

class Notificationoperation {
  static const int interval = -1;

  Future<void> notification() async {
    tz.initializeTimeZones();
    final preferences = await SharedPreferences.getInstance();
    var notificationbool = preferences.getBool('notificationbool') ?? true;
    if (notificationbool == true) {
      int targetlength = await DrfDatabase().listlength();
      var notificationtarget = await DrfDatabase().getData(0);
      var index = targetlength;
      if (notificationtarget.length != targetlength) {
        final flutterLocalNotificationsPlugin =
            FlutterLocalNotificationsPlugin();
        flutterLocalNotificationsPlugin.initialize(const InitializationSettings(
            android: AndroidInitializationSettings('app_icon'),
            iOS: IOSInitializationSettings()));
        while (index < notificationtarget.length) {
          var deadline = DateTime.parse(notificationtarget[index]['date'])
              .add(const Duration(minutes: interval));
          var now = DateTime.now();
          var dif = deadline.difference(now).inSeconds;
          if (dif <= (-interval) * 60) {
            dif = 1;
          }
          flutterLocalNotificationsPlugin.cancel(index);
          await flutterLocalNotificationsPlugin.zonedSchedule(
            index,
            '〆切が迫っています。',
            "${notificationtarget[index]['title']}",
            tz.TZDateTime.from(DateTime.now(), tz.local)
                .add(Duration(seconds: dif)),
            const NotificationDetails(
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
