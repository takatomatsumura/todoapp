import 'dart:async';
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:todoapp/main.dart';

class DrfDatabase {
  final dio = Dio();
  List datalist = [];
  var data;
  final domain2 = '10.0.2.2:8000';
  // final domain = '18.180.75.44';

  Future sampleData(int _index, String uuid) async {
    final dio = Dio();
    final response = await dio.get(
      'http://$domain2/todos/sample/$_index/$uuid',
    );
    var _jsonlist = response.data['todo'];
    var _datalist = jsonDecode(_jsonlist);
    return _datalist;
  }

  Future sampleData3(String uuid) async {
    final dio = Dio();
    final response = await dio.get(
      'http://$domain2/todos/sample/len/$uuid',
    );
    var _jsonlist = response.data['listlen'];
    return _jsonlist;
  }

  // ignore: type_annotate_public_apis
  Future<Map<String, dynamic>> retrieveData(var index) async {
    final dio = Dio();
    final responce = await dio.get(
      'http://$domain2/todos/retrieve/$index',
    );
    data = responce.data as Map<String, dynamic>;
    return data;
  }

  Future postData(String title, String date, String image, int owner) async {
    final dio = Dio();
    final response = await dio.post(
      'http://$domain2/todos/create',
      data: {
        'title': title,
        'date': date,
        'donebool': false,
        'image': image,
        'owner': owner,
      },
    );
    data = response.data;
  }

  // ignore: type_annotate_public_apis
  Future updateData(
      var index, String title, String date, String image, int owner) async {
    final dio = Dio();
    final response = await dio.patch(
      'http://$domain2/todos/update/$index',
      data: {
        'title': title,
        'date': date,
        'image': image,
        'owner': owner,
      },
    );
    data = response.data;
  }

  Future boolchange(int pk, {required bool boolvalue}) async {
    final dio = Dio();
    final response = await dio.patch(
      'http://$domain2/todos/update/$pk',
      data: {
        'donebool': boolvalue,
      },
    );
    data = response.data;
  }

  Future deleteData(int pk) async {
    final dio = Dio();
    final responce = await dio.delete(
      'http://$domain2/todos/delete/$pk',
    );
    data = responce.data;
  }

  Future userretrieve(String uuid) async {
    final dio = Dio();
    final responce = await dio.get(
      'http://$domain2/todos/user/retrieve/$uuid',
    );
    return responce.data['todouser'];
  }

  Future usercreate(String uuid) async {
    final responce = await dio.post(
      'http://$domain2/todos/user/create',
      data: {
        'uuid': uuid,
        'name': 'name1',
      },
    );
    data = responce.data;
    print(data);
    return data;
  }
}

class Notificationoperation {
  static const int interval = -1;
  Future<void> notification() async {
    tz.initializeTimeZones();
    final preferences = await SharedPreferences.getInstance();
    var notificationbool = preferences.getBool('notificationbool') ?? true;
    if (notificationbool == true) {
      var uuid = await Getuuid().getuuid();
      int targetlength = await DrfDatabase().sampleData3(uuid);
      var notificationtarget = await DrfDatabase().sampleData(0, uuid);
      var index = targetlength;
      if (notificationtarget.length != targetlength) {
        final flutterLocalNotificationsPlugin =
            FlutterLocalNotificationsPlugin();
        flutterLocalNotificationsPlugin.initialize(const InitializationSettings(
            android: AndroidInitializationSettings('icon'),
            iOS: IOSInitializationSettings()));
        while (index < notificationtarget.length) {
          var deadline =
              DateTime.parse(notificationtarget[index]['fields']['date'])
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
            "${notificationtarget[index]['fields']['title']}",
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
