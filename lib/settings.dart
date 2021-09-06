import 'package:flutter/material.dart';
import 'package:todoapp/operation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SettingPageWidget(title: 'Sample Aplication'),
    );
  }
}

class SettingPageWidget extends StatefulWidget {
  SettingPageWidget({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _SettingPageStateWidget createState() => _SettingPageStateWidget();
}

class _SettingPageStateWidget extends State<SettingPageWidget> {
  bool switchvalue = true;

  void setpreferences({required bool value}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('notificationbool', value);
  }

  void getpreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      switchvalue = prefs.getBool('notificationbool') ?? true;
    });
  }

  @override
  void initState() {
    super.initState();
    getpreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              const Icon(Icons.notifications),
              const Text(
                '通知',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Switch.adaptive(
                value: switchvalue,
                onChanged: (value) async {
                  setpreferences(value: value);
                  setState(() {
                    switchvalue = value;
                  });
                  await Notificationoperation().notification();
                },
              ),
            ]),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/user');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.person),
                    const Text(
                      'ユーザー設定',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ))
          ]),
    );
  }
}
