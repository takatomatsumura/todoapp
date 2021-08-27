import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/form.dart';
import 'package:todoapp/operation.dart';
import 'dart:convert';
import "package:intl/intl.dart";
import 'package:todoapp/main.dart';

class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var id = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_sharp),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              "/home",
              (_) => false,
            );
            // Navigator.pop(context);
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
      body: Detail(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.pushNamed(context, "/form", arguments: detail[0]["id"]);
          Navigator.pushNamed(context, "/form", arguments: id);
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}

class Detail extends StatelessWidget {
  final datetimeformat = DateFormat("y-M-d HH:mm");
  @override
  Widget build(BuildContext context) {
    var id = ModalRoute.of(context)!.settings.arguments;
    // List detail = [];
    // var data;
    // Future detailshow() async {
    //   // detail = await Databaseoperation().idselect(id);
    //   data = await LocalDatabase().retrieveData(id);
    //   return data;
    // }

    return ListView(children: <Widget>[
      FutureBuilder<Map<String, dynamic>>(
        future: LocalDatabase().retrieveData(id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            return DefaultTextStyle(
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                height: 2,
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("タイトル：")),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 250,
                              child: Text(
                                // "${detail[0]['title']}",
                                "${data!['title']}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                              ),
                            ),
                          )
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("〆切日時：")),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              // "${detail[0]['date']}",
                              "${datetimeformat.format(DateTime.parse(data['date']))}",
                            ),
                          )
                        ]),
                    // Row(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     children: <Widget>[
                    //       Padding(
                    //           padding: EdgeInsets.all(8.0),
                    //           child: Text("〆切時間：")),
                    //       Padding(
                    //         padding: EdgeInsets.all(8.0),
                    //         child: Text(
                    //             // "${detail[0]['time']}",
                    //             "${datetimeformat.format(DateTime.parse(data['date']))}"),
                    //       )
                    //     ]),
                    Text("画像"),
                    // (detail[0]["image"] == "null" || detail[0]["image"] == "")
                    (data["image"] == "null" || data["image"] == "")
                        ? Text("画像はありません")
                        : ConstrainedBox(
                            constraints:
                                BoxConstraints(maxWidth: 300, maxHeight: 300),
                            child: Image.memory(
                                // base64Decode(detail[0]["image"]))),
                                base64Decode(data["image"]))),
                  ]),
            );
          } else {
            return Container();
          }
        },
      ),
    ]);
  }
}
