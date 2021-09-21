import 'dart:async';
import 'dart:io';
import 'package:todoapp/operation.dart';
import 'package:todoapp/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

var _id;

class FormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _id = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
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
      body: _FormPageWidget(title: 'Sample Aplication'),
    );
  }
}

class _FormPageWidget extends StatefulWidget {
  _FormPageWidget({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _FormPageStateWidget createState() => _FormPageStateWidget();
}

class _FormPageStateWidget extends State<_FormPageWidget> {
  final _formkey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final datetimeformat = DateFormat('y-M-d HH:mm');
  String minute = '';
  String hour = '';
  String datestring = '';
  String timestring = '';
  var _image;
  final picker = ImagePicker();
  String uuid = '';
  String detailimage = '';
  var _todouser;
  var _detail;
  final dateformat = DateFormat('y-M-d');
  final timeformat = DateFormat('HH:mm');
  var _requestimage;
  String? _imageurl;

  Future _getImagecamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _requestimage = pickedFile.path;
      }
    });
  }

  Future _getImagegallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _requestimage = pickedFile.path;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (_id != '') {
      Future(() async {
        _detail = await DrfDatabase().retrievetodo(_id);
        titleController.text = _detail['title'];
        dateController.text = dateformat.format(
            DateTime.parse(_detail['date']).add(const Duration(hours: 9)));
        timeController.text = timeformat.format(
            DateTime.parse(_detail['date']).add(const Duration(hours: 9)));
        _imageurl = _detail['image'];
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(children: <Widget>[
          Form(
              key: _formkey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: titleController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'タイトル',
                        labelText: 'タイトル',
                        filled: true,
                      ),
                      validator: (_titlevalue) {
                        if (_titlevalue == null || _titlevalue.isEmpty) {
                          return '必須項目です';
                        } else if (200 <= _titlevalue.length) {
                          return '200文字までしか入力できません。';
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: dateController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '〆切日時',
                        labelText: '〆切日時',
                        filled: true,
                      ),
                      validator: (_datevalue) {
                        if (_datevalue == null || _datevalue.isEmpty) {
                          return '必須項目です';
                        }
                      },
                      onTap: () async {
                        final _selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(DateTime.now().year),
                          lastDate: DateTime(DateTime.now().year + 1),
                        );

                        if (_selectedDate != null) {
                          datestring =
                              '''${dateformat.format(_selectedDate)}''';
                        }
                        dateController.text = dateformat.format(_selectedDate!);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: timeController,
                      readOnly: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '〆切時間',
                          labelText: '〆切時間',
                          filled: true),
                      validator: (_timevalue) {
                        if (_timevalue == null || _timevalue.isEmpty) {
                          return '必須項目です';
                        }
                        return null;
                      },
                      onTap: () async {
                        final _selectedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (_selectedTime != null) {
                          if (_selectedTime.minute < 10) {
                            minute = '0${_selectedTime.minute}';
                          } else {
                            minute = '${_selectedTime.minute}';
                          }
                          if (_selectedTime.hour > 9) {
                            hour = '${_selectedTime.hour}';
                          } else {
                            hour = '0${_selectedTime.hour}';
                          }
                          timestring = '$hour:$minute';
                        }
                        timeController.text = timestring;
                      },
                    ),
                  ),
                  _image == null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _imageurl == null
                              ? const Text('画像が選択されていません。')
                              : ConstrainedBox(
                                  constraints: const BoxConstraints(
                                      maxHeight: 300, maxWidth: 300),
                                  child: Image.network(_imageurl!),
                                ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                                maxHeight: 300, maxWidth: 300),
                            child: Image.file(_image),
                          )),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          child: const Icon(Icons.camera_alt),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            onPrimary: Colors.white,
                            shape: const CircleBorder(),
                          ),
                          onPressed: _getImagecamera,
                        ),
                        ElevatedButton(
                          child: const Icon(Icons.photo),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            onPrimary: Colors.white,
                            shape: const CircleBorder(),
                          ),
                          onPressed: _getImagegallery,
                        ),
                      ]),
                  ElevatedButton(
                    child: const Text('保存'),
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        uuid = await Getuuid().getuuid();
                        _todouser = await DrfDatabase().userretrieve(uuid);
                        if (_id == '') {
                          await Notificationoperation().notification();
                          await DrfDatabase().createtodo(
                            titleController.text,
                            '$datestring $timestring',
                            _todouser['id'],
                            _requestimage,
                          );
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/home',
                            (_) => false,
                          );
                        } else {
                          await Notificationoperation().notification();
                          await DrfDatabase().updatetodo(
                            _id,
                            titleController.text,
                            '${dateController.text} ${timeController.text}',
                            _todouser['id'],
                            _requestimage,
                          );
                          Navigator.pushNamed(context, '/detail',
                              arguments: _id);
                        }
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Processing Data'),
                        ));
                      }
                    },
                  ),
                ],
              )),
        ]),
      ),
    );
  }
}
