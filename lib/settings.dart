import 'package:flutter/material.dart';
import 'package:todoapp/operation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage2 extends StatelessWidget {
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
      body: SettingPage(title: 'Sample Aplication'),
    );
  }
}

class SettingPage extends StatefulWidget {
  SettingPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool switchvalue = true;

  setpreferences(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('notificationbool', value);
  }

  getpreferences() async {
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
      body: Center(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          const Text(
            '通知',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Switch.adaptive(
            value: switchvalue,
            onChanged: (bool value) {
              setpreferences(value);
              setState(() {
                switchvalue = value;
              });
              Notificationoperation().notification();
            },
          ),
        ]),
      ),
    );
  }
}
