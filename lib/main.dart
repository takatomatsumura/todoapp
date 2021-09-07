// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/operation.dart';
import 'package:todoapp/detail.dart';
import 'package:todoapp/settings.dart';
import 'package:todoapp/form.dart';
import 'package:todoapp/homepage.dart';
import 'package:todoapp/user.dart';
import 'package:todoapp/username.dart';
import 'package:todoapp/userdisplay.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
bool? initialbool;

class FirstLogin {
  var _uuid;
  var _todouser;
  Future<void> login() async {
    AuthResult user = await firebaseAuth.signInAnonymously();
    _uuid = user.user.uid;
    // _uuid = 'uuidsample';
    _todouser = await DrfDatabase().userretrieve(_uuid);
    if (_todouser['uuid'] == null) {
      await DrfDatabase().usercreate(_uuid);
      initialbool = true;
    } else {
      initialbool = false;
    }
  }
}

class Getuuid {
  Future<String> getuuid() async {
    AuthResult _user = await firebaseAuth.signInAnonymously();
    String _uuid = _user.user.uid;
    return _uuid;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirstLogin().login();
  if (initialbool == false) {
    await Notificationoperation().notification();
  }
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
        initialRoute: initialbool == false ? '/home' : '/username',
        routes: {
          '/home': (context) => MyHomePage(
                title: 'flutter home',
              ),
          '/form': (context) => FormPage(),
          '/detail': (context) => DetailPage(),
          '/setting': (context) => SettingPage(),
          '/user': (context) => UserSetting(),
          '/username': (context) => UserName(),
          '/displayuser': (context) => UserDisplay(),
        });
  }
}
