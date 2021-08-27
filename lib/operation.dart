// import 'dart:async';
// import 'package:flutter/gestures.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;
// import "package:intl/intl.dart";
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
// import 'package:todoapp/data.dart';
// import 'dart:convert';

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

// class Databaseoperation {
//   final String dbName = "sqflite4.db";
//   final int dbVersion = 1;
//   final String tableName = "address";
//   int overduelength = 0;
//   DateTime now = DateTime.now().toLocal();
//   String month = "";
//   String day = "";
//   String hour = "";
//   String minute = "";
//   int datetime = 0;
//   void datearrange() {
//     if (now.month < 10) {
//       month = "0${now.month}";
//     } else {
//       month = "${now.month}";
//     }
//     if (now.day < 10) {
//       day = "0${now.day}";
//     } else {
//       day = "${now.day}";
//     }
//     if (now.hour < 10) {
//       hour = "0${now.hour}";
//     } else {
//       hour = "${now.hour}";
//     }
//     if (now.minute < 10) {
//       minute = "0${now.minute}";
//     } else {
//       minute = "${now.minute}";
//     }
//     datetime = int.parse("${now.year}$month$day$hour$minute");
//   }

//   Future<Database> databasevar() async {
//     String dbFieldPath = await getDatabasesPath();
//     String path = join(dbFieldPath, dbName);
//     Database db = await openDatabase(path, version: dbVersion,
//         onCreate: (Database db, int version) async {
//       await db.execute(
//           "CREATE TABLE IF NOT EXISTS $tableName (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, bool TEXT, datetime INTEGER, image TEXT)");
//     });
//     return db;
//   }

//   boolselect(int boolvalue) async {
//     Database database = await databasevar();
//     List<Map> result = await database.rawQuery(
//         'SELECT * FROM $tableName WHERE bool=$boolvalue ORDER BY datetime ASC');
//     return result;
//   }

//   opacitynumber() async {
//     Database database = await databasevar();
//     datearrange();
//     List<Map> dateresult = await database.rawQuery(
//         'SELECT * FROM $tableName WHERE datetime<=$datetime AND bool=0 ORDER BY datetime ASC');
//     overduelength = dateresult.length;
//     return overduelength;
//   }

//   idselect(var id) async {
//     Database database = await databasevar();
//     List<Map> result =
//         await database.rawQuery('SELECT * FROM $tableName WHERE id=$id');
//     return result;
//   }

//   void save(String title, String date, String time, int datetime,
//       var uintlist) async {
//     int initialbool = 0;
//     Database database = await databasevar();
//     String query =
//         'INSERT INTO $tableName (title, date, time, bool, datetime, image) VALUES("$title", "$date", "$time", "$initialbool", $datetime, "$uintlist")';

//     await database.transaction((txn) async {
//       await txn.rawInsert(query);
//     });
//   }

//   void delete(int id) async {
//     String sql = 'DELETE FROM $tableName WHERE id=$id';
//     // String sql = 'DELETE FROM $tableName';
//     Database database = await databasevar();
//     await database.transaction((txn) async {
//       await txn.rawDelete(sql);
//     });
//   }

//   void update(var id, String title, String date, String time, int datetime,
//       var uintlist) async {
//     int initialbool = 0;
//     String sql =
//         'UPDATE $tableName SET title="$title", date="$date", time="$time", bool="$initialbool", datetime=$datetime, image="$uintlist" WHERE id=$id';
//     Database database = await databasevar();
//     await database.transaction((txn) async {
//       await txn.rawUpdate(sql);
//     });
//   }

//   void changebool(int id, int boolvalue) async {
//     Database database = await databasevar();
//     String sql = 'UPDATE $tableName SET bool=$boolvalue WHERE id=$id';
//     await database.transaction((txn) async {
//       await txn.rawUpdate(sql);
//     });
//   }
// }

// class Notificationoperation {
//   static const int interval = -1;

//   void notification() async {
//     tz.initializeTimeZones();
//     final SharedPreferences preferences = await SharedPreferences.getInstance();
//     bool notificationbool = preferences.getBool("notificationbool") ?? true;
//     if (notificationbool == true) {
//       int targetlength = await Databaseoperation().opacitynumber();
//       List notificationtarget = await Databaseoperation().boolselect(0);
//       int index = targetlength;
//       if (notificationtarget.length != targetlength) {
//         final datetimeformat = DateFormat("y-M-d HH:mm");
//         final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//             FlutterLocalNotificationsPlugin();
//         flutterLocalNotificationsPlugin.initialize(InitializationSettings(
//             android: AndroidInitializationSettings("app_icon"),
//             iOS: IOSInitializationSettings()));
//         while (index < notificationtarget.length) {
//           DateTime deadline = datetimeformat
//               .parseStrict(
//                   "${notificationtarget[index]['date']} ${notificationtarget[index]['time']}")
//               .add(Duration(minutes: interval));
//           DateTime now = DateTime.now();
//           int dif = deadline.difference(now).inSeconds;
//           if (dif <= (-interval) * 60) {
//             dif = 1;
//           }
//           flutterLocalNotificationsPlugin.cancel(index);
//           await flutterLocalNotificationsPlugin.zonedSchedule(
//             index,
//             "〆切が迫っています。",
//             "${notificationtarget[index]['title']}",
//             tz.TZDateTime.from(DateTime.now(), tz.local)
//                 .add(Duration(seconds: dif)),
//             NotificationDetails(
//               android: AndroidNotificationDetails('your channel id',
//                   'your channel name', 'your channel description',
//                   importance: Importance.max, priority: Priority.high),
//               iOS: IOSNotificationDetails(),
//             ),
//             uiLocalNotificationDateInterpretation:
//                 UILocalNotificationDateInterpretation.absoluteTime,
//             androidAllowWhileIdle: true,
//           );
//           index++;
//         }
//       }
//     }
//   }
// }
