import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/operation.dart';

class UserName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UserName'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
              (_) => false,
            );
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
      body: _UserNameWidget(title: 'Sample Aplication'),
    );
  }
}

class _UserNameWidget extends StatefulWidget {
  _UserNameWidget({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _UserNameStateWidget createState() => _UserNameStateWidget();
}

class _UserNameStateWidget extends State {
  final _formkey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  var _uuid;
  var _user;

  @override
  void initState() {
    super.initState();
    Future(() async {
      _uuid = await Getuuid().getuuid();
      _user = await DrfDatabase().userretrieve(_uuid);
      if (_user != null) {
        setState(() {
          _nameController.text = _user['name'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('みんながわかる名前を入力してください。'),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
              child: TextFormField(
                controller: _nameController,
                autofocus: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'ユーザー名',
                  labelText: 'ユーザー名',
                  filled: true,
                ),
                validator: (_namevalue) {
                  if (_namevalue == null || _namevalue.isEmpty) {
                    return '必須項目です';
                  } else if (100 <= _namevalue.length) {
                    return '100文字までしか入力できません。';
                  }
                },
              ),
            ),
            ElevatedButton(
              child: const Text('保存'),
              onPressed: () async {
                if (_formkey.currentState!.validate()) {
                  await DrfDatabase()
                      .userupdate(_nameController.text, _user['id']);
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (_) => false,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Processing Data'),
                  ));
                }
              },
            ),
          ]),
    );
  }
}
