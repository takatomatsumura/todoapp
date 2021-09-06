import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/operation.dart';
import 'package:todoapp/main.dart';

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
      ),
      body: UserDisplayWidget(title: 'Sample Aplication'),
    );
  }
}

class UserDisplayWidget extends StatefulWidget {
  UserDisplayWidget({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _UserDisplayStateWidget createState() => _UserDisplayStateWidget();
}

class _UserDisplayStateWidget extends State<UserDisplayWidget> {
  List _userlist = [];
  List<bool> _checkvalue = [];
  String _uuid = '';
  int? userindex;
  int? userid;
  List _truelist = [];
  Map user = {};
  @override
  void initState() {
    super.initState();
    Future(() async {
      _checkvalue = [];
      _userlist = await DrfDatabase().userlist();
      _uuid = await Getuuid().getuuid();
      user = await DrfDatabase().userretrieve(_uuid);
      _userlist.asMap().forEach((_index, _value) {
        if (_value['uuid'] == _uuid) {
          userindex = _index;
          userid = _value['id'];
          _truelist = _value['displayuser'];
        } else {
          _checkvalue.add(false);
        }
      });
      _userlist.removeAt(userindex!);
      _truelist.asMap().forEach((_index, _value) {
        _userlist.asMap().forEach((index, value) {
          if (_value == value['id']) {
            _checkvalue[index] = true;
          }
        });
      });
      _userlist.add('');
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_userlist.isNotEmpty) {
      return ListView.builder(
          itemCount: _userlist.length,
          itemBuilder: (context, index) {
            if (index != _userlist.length - 1) {
              return ListTile(
                title: Text('${_userlist[index]['name']}'),
                trailing: Checkbox(
                  value: _checkvalue[index],
                  onChanged: (boolvalue) {
                    setState(() {
                      _checkvalue[index] = boolvalue!;
                    });
                  },
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      _truelist = [];
                      _checkvalue.asMap().forEach((index, element) {
                        if (element == true) {
                          _truelist.add(_userlist[index]['id']);
                        }
                      });
                      _truelist.add(userid);
                      await DrfDatabase().userdisplayupdate(_truelist, userid!);
                      await Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        (_) => false,
                      );
                    },
                    child: const Text('送信'),
                  ),
                ),
              );
            }
          });
    } else {
      return const Text('ユーザーが取得できません。');
    }
  }
}
