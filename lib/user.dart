import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserSetting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/username');
                },
                child: const Text('ユーザー名の変更'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/displayuser');
                },
                child: const Text('表示するユーザーの変更'),
              ),
            ]),
      ),
    );
  }
}
