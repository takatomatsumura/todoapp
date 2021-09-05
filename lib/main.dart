import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/operation.dart';
import 'package:todoapp/detail.dart';
import 'package:todoapp/settings.dart';
import 'package:todoapp/form.dart';
import 'package:todoapp/homepage.dart';

class FirstLogin {
  var uuid;
  var todouser;
  Future<void> login() async {
    AuthResult user = await firebaseAuth.signInAnonymously();
    uuid = user.user.uid;
    // uuid = 'uuid50';
    todouser = await DrfDatabase().userretrieve(uuid);
    if (todouser['uuid'] == null) {
      await DrfDatabase().usercreate(uuid);
    }
  }
}

class Getuuid {
  Future<String> getuuid() async {
    AuthResult user = await firebaseAuth.signInAnonymously();
    String uuid = user.user.uid;
    // uuid = 'uuid50';
    return uuid;
  }
}

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Notificationoperation().notification();
  await FirstLogin().login();
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
