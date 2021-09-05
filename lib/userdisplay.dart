import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/operation.dart';

class UserDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DisplayUser'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.settings),
              color: Colors.white,
              iconSize: 40,
              onPressed: () {
                Navigator.pushNamed(context, '/setting');
              })
        ],
      ),
      body: _UserDisplayWidget(title: 'Sample Aplication'),
    );
  }
}

class _UserDisplayWidget extends StatefulWidget {
  _UserDisplayWidget({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _UserDisplayStateWidget createState() => _UserDisplayStateWidget();
}

class _UserDisplayStateWidget extends State {
  List _userlist = [];
  Future<List> showuser() async {
    _userlist = await DrfDatabase().userlist();
    return _userlist;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: showuser(),
      builder: (context, snapshot) {
        if (snapshot.hasData && _userlist.isNotEmpty) {
          return ListView.builder(
            itemCount: _userlist.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('${_userlist[index]['name']}'),
              );
            },
          );
        } else {
          return const Text('ユーザーを取得することができません。');
        }
      },
    );
  }
}
