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
  var _data;
  final domain2 = '10.0.2.2:8000';
  // final domain = '18.180.75.44';

  Future gettodolist(int _index, String _uuid) async {
    final response = await dio.get(
      'http://$domain2/todos/todolist/$_index/$_uuid',
    );
    var _jsonlist = response.data['todo'];
    var _datalist = jsonDecode(_jsonlist);
    return _datalist;
  }

  Future getopacitylength(String _uuid) async {
    final response = await dio.get(
      'http://$domain2/todos/todolist/len/$_uuid',
    );
    var _jsonlist = response.data['listlen'];
    return _jsonlist;
  }

  // ignore: type_annotate_public_apis
  Future<Map<String, dynamic>> retrievetodo(var _index) async {
    final responce = await dio.get(
      'http://$domain2/todos/retrieve/$_index',
    );
    _data = responce.data as Map<String, dynamic>;
    return _data;
  }

  Future createtodo(
      String _title, String _date, String _image, int _owner) async {
    final response = await dio.post(
      'http://$domain2/todos/create',
      data: {
        'title': _title,
        'date': _date,
        'donebool': false,
        'image': _image,
        'owner': _owner,
      },
    );
    _data = response.data;
  }

  Future updatetodo(int _index, String _title, String _date, String _image,
      int _owner) async {
    final dio = Dio();
    final response = await dio.patch(
      'http://$domain2/todos/update/$_index',
      data: {
        'title': _title,
        'date': _date,
        'image': _image,
        'owner': _owner,
      },
    );
    _data = response.data;
  }

  Future boolchange(int _pk, {required bool boolvalue}) async {
    final response = await dio.patch(
      'http://$domain2/todos/update/$_pk',
      data: {
        'donebool': boolvalue,
      },
    );
    _data = response.data;
  }

  Future deletetodo(int _pk) async {
    final responce = await dio.delete(
      'http://$domain2/todos/delete/$_pk',
    );
    _data = responce.data;
  }

  Future userretrieve(String _uuid) async {
    final responce = await dio.get(
      'http://$domain2/todos/user/retrieve/$_uuid',
    );
    return responce.data['todouser'];
  }

  Future usercreate(String _uuid) async {
    final responce = await dio.post(
      'http://$domain2/todos/user/create',
      data: {
        'uuid': _uuid,
        'name': 'name',
      },
    );
    _data = responce.data;
  }

  Future usernameupdate(String _username, int _pk) async {
    final response = await dio.patch(
      'http://$domain2/todos/user/update/$_pk',
      data: {
        'name': _username,
      },
    );
    _data = response.data;
  }

  Future userlist() async {
    final responce = await dio.get(
      'http://$domain2/todos/user/list',
    );
    _data = responce.data;
    return _data;
  }

  Future userdisplayupdate(List _displayuser, int _pk) async {
    final response = await dio.patch(
      'http://$domain2/todos/user/update/$_pk',
      data: {
        'displayuser': _displayuser,
      },
    );
    _data = response.data;
  }

  Future getnotificationtarget(String _uuid) async {
    final response = await dio.get(
      'http://$domain2/todos/notificationtarget/$_uuid',
    );
    var _jsonlist = response.data['todo'];
    var _datalist = jsonDecode(_jsonlist);
    return _datalist;
  }

  Future gettargetlength(String _uuid) async {
    final response = await dio.get(
      'http://$domain2/todos/notification/overdue/$_uuid',
    );
    var _jsonlist = response.data['listlen'];
    return _jsonlist;
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
      int targetlength = await DrfDatabase().gettargetlength(uuid);
      var notificationtarget = await DrfDatabase().getnotificationtarget(uuid);
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
