import 'package:todoapp/operation.dart';
import 'package:todoapp/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import "package:intl/intl.dart";
import 'dart:async';

class FormPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_sharp),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.settings),
              color: Colors.white,
              iconSize: 40,
              onPressed: () {
                Navigator.pushNamed(context, "/setting");
              })
        ],
      ),
      body: _FormPage(title: 'Sample Aplication'),
    );
  }
}

class _FormPage extends StatefulWidget {
  _FormPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<_FormPage> {
  final _formkey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final datetimeformat = DateFormat("y-M-d HH:mm");
  String datestring = "";
  String timestring = "";
  // String month = "";
  // String day = "";
  // String hour = "";
  // String minute = "";
  // String datetimedate = "";
  // String datetimetime = "";
  // int datetime = 0;
  var _image;
  final picker = ImagePicker();
  var uintlist;
  String img64 = "";

  Future _getImagecamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      uintlist = File(pickedFile.path).readAsBytesSync();
      img64 = base64Encode(uintlist);
    }
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future _getImagegallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      uintlist = File(pickedFile.path).readAsBytesSync();
      img64 = base64Encode(uintlist);
    }
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var id = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      body: Center(
        child: ListView(children: <Widget>[
          Form(
              key: _formkey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: titleController,
                      autofocus: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "タイトル",
                        labelText: "タイトル",
                        filled: true,
                      ),
                      validator: (titlevalue) {
                        if (titlevalue == null || titlevalue.isEmpty) {
                          return '必須項目です';
                        } else if (200 <= titlevalue.length) {
                          return "200文字までしか入力できません。";
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Stack(children: <Widget>[
                      TextFormField(
                        controller: dateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "〆切日時",
                          labelText: "〆切日時",
                          filled: true,
                        ),
                        validator: (datevalue) {
                          if (datevalue == null || datevalue.isEmpty) {
                            return '必須項目です';
                          }
                        },
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 62,
                        child: FlatButton(
                          onPressed: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(DateTime.now().year),
                              lastDate: DateTime(DateTime.now().year + 1),
                            );

                            if (selectedDate != null) {
                              datestring =
                                  "${selectedDate.year}-${selectedDate.month}-${selectedDate.day} ";
                              //   if (selectedDate.month < 10) {
                              //     month = "0${selectedDate.month}";
                              //   } else {
                              //     month = "${selectedDate.month}";
                              //   }
                              //   if (selectedDate.day < 10) {
                              //     day = "0${selectedDate.day}";
                              //   } else {
                              //     day = "${selectedDate.day}";
                              //   }
                              //   datetimedate = "${selectedDate.year}$month$day";
                            }
                            dateController.text = datestring;
                          },
                          child: Container(),
                        ),
                      )
                    ]),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Stack(children: <Widget>[
                      TextFormField(
                        controller: timeController,
                        readOnly: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "〆切時間",
                            labelText: "〆切時間",
                            filled: true),
                        validator: (timevalue) {
                          if (timevalue == null || timevalue.isEmpty) {
                            return '必須項目です';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 62,
                        child: FlatButton(
                          onPressed: () async {
                            final selectedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );

                            if (selectedTime != null) {
                              timestring =
                                  "${selectedTime.hour}:${selectedTime.minute}";
                              // if (selectedTime.hour < 10) {
                              //   hour = "0${selectedTime.hour}";
                              // } else {
                              //   hour = "${selectedTime.hour}";
                              // }
                              // if (selectedTime.minute < 10) {
                              //   minute = "0${selectedTime.minute}";
                              // } else {
                              //   minute = "${selectedTime.minute}";
                              // }
                              // datetimetime = "$hour$minute";
                            }
                            timeController.text = timestring;
                          },
                          child: Container(),
                        ),
                      ),
                    ]),
                  ),
                  _image == null
                      ? Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("画像が選択されていません。"),
                        )
                      : Padding(
                          padding: EdgeInsets.all(8.0),
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints(maxHeight: 300, maxWidth: 300),
                            child: Image.file(_image),
                          )),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          child: Icon(Icons.camera_alt),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            onPrimary: Colors.white,
                            shape: CircleBorder(),
                          ),
                          onPressed: () {
                            _getImagecamera();
                          },
                        ),
                        ElevatedButton(
                          child: Icon(Icons.photo),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            onPrimary: Colors.white,
                            shape: CircleBorder(),
                          ),
                          onPressed: () {
                            _getImagegallery();
                          },
                        ),
                      ]),
                  RaisedButton(
                    child: Text("保存"),
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        // datetime = int.parse(datetimedate + datetimetime);
                        if (id == "") {
                          // Databaseoperation().save(
                          //     titleController.text,
                          //     dateController.text,
                          //     timeController.text,
                          //     datetime,
                          //     img64);
                          // Notificationoperation().notification();
                          LocalDatabase().postData(titleController.text,
                              datestring + timestring, img64);
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            "/home",
                            (_) => false,
                          );
                        } else {
                          // Databaseoperation().update(
                          //     id,
                          //     titleController.text,
                          //     dateController.text,
                          //     timeController.text,
                          //     datetime,
                          //     img64);
                          // Notificationoperation().notification();
                          LocalDatabase().updateData(
                            id,
                            titleController.text,
                            datestring + timestring,
                            img64,
                          );
                          Navigator.pushNamed(context, "/detail",
                              arguments: id);
                          // Navigator.pop(context);
                        }
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Processing Data"),
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
