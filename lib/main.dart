import 'package:flutter/material.dart';
import 'package:todoapp/operation.dart';
import 'package:todoapp/detail.dart';
import 'package:todoapp/settings.dart';
import 'package:todoapp/form.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todoapp/data.dart';
import "package:intl/intl.dart";

void main() async {
  // Notificationoperation().notification();
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
        initialRoute: "/home",
        routes: {
          "/home": (context) => MyHomePage(
                title: "flutter home",
              ),
          "/form": (context) => FormPage2(),
          "/detail": (context) => DetailPage(),
          "/setting": (context) => SettingPage2(),
          "/data": (context) => Data(),
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List items = [];
  int overduelength = 0;
  final datetimeformat = DateFormat("y-M-d HH:mm");

  // Future todoitem(int boolvalue) async {
  //   items = await Databaseoperation().boolselect(boolvalue);
  //   overduelength = await Databaseoperation().opacitynumber();
  //   return items;
  // }

  Future todoitem(int index) async {
    items = await LocalDatabase().getData(index);
    overduelength = await LocalDatabase().listlength();
    return items;
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Todo"),
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
        body: Center(
          child: FutureBuilder(
              future: todoitem(_selectedIndex),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (_selectedIndex == 0) {
                  if (snapshot.hasData && items.length != 0) {
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        if (index < overduelength) {
                          return Opacity(
                            opacity: 0.5,
                            child: RaisedButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: 1.0, horizontal: 0),
                              elevation: 3.0,
                              onPressed: () {
                                Navigator.pushNamed(context, "/detail",
                                    arguments: items[index]["id"]);
                              },
                              child: Slidable(
                                actionPane: SlidableDrawerActionPane(),
                                actionExtentRatio: 0.25,
                                child: Container(
                                  color: Colors.white,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.indigoAccent,
                                      child: Text(''),
                                      foregroundColor: Colors.white,
                                    ),
                                    title: Text(
                                      "???????????????${items[index]['title']}",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                    subtitle: Text(
                                        // "???????????????${items[index]['date']} ${items[index]['time']}"),
                                        items[index]["date"] != null
                                            ? "???????????????${datetimeformat.format(DateTime.parse(items[index]["date"]).add(Duration(hours: 9)))}"
                                            : ""),
                                  ),
                                ),
                                actions: <Widget>[
                                  IconSlideAction(
                                    caption: "delete",
                                    color: Colors.red,
                                    icon: Icons.delete,
                                    onTap: () async {
                                      // Databaseoperation()
                                      //     .delete(items[index]["id"]);
                                      await LocalDatabase()
                                          .deleteData(items[index]["id"]);
                                      setState(() {});
                                    },
                                  ),
                                  IconSlideAction(
                                    caption: "edit",
                                    color: Colors.yellow,
                                    icon: Icons.edit,
                                    onTap: () {
                                      Navigator.pushNamed(context, "/form",
                                          arguments: items[index]["id"]);
                                    },
                                  ),
                                ],
                                secondaryActions: <Widget>[
                                  IconSlideAction(
                                    caption: "done",
                                    color: Colors.lime,
                                    icon: Icons.check,
                                    onTap: () async {
                                      await LocalDatabase()
                                          .boolchange(items[index]["id"], true);
                                      // Databaseoperation()
                                      //     .changebool(items[index]["id"], 1);
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return RaisedButton(
                            padding: EdgeInsets.symmetric(
                                vertical: 1.0, horizontal: 0),
                            elevation: 3.0,
                            onPressed: () {
                              Navigator.pushNamed(context, "/detail",
                                  arguments: items[index]["id"]);
                            },
                            child: Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.25,
                              child: Container(
                                color: Colors.white,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.indigoAccent,
                                    child: Text(''),
                                    foregroundColor: Colors.white,
                                  ),
                                  title: Text(
                                    "???????????????${items[index]['title']}",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  subtitle: Text(
                                      // "???????????????${items[index]['date']} ${items[index]['time']}"),
                                      items[index]["date"] != null
                                          ? "???????????????${datetimeformat.format(DateTime.parse(items[index]["date"]).add(Duration(hours: 9)))}"
                                          : ""),
                                ),
                              ),
                              actions: <Widget>[
                                IconSlideAction(
                                  caption: "delete",
                                  color: Colors.red,
                                  icon: Icons.delete,
                                  onTap: () async {
                                    // Databaseoperation()
                                    //     .delete(items[index]["id"]);
                                    await LocalDatabase()
                                        .deleteData(items[index]["id"]);
                                    // Notificationoperation().notification();
                                    setState(() {});
                                  },
                                ),
                                IconSlideAction(
                                  caption: "edit",
                                  color: Colors.yellow,
                                  icon: Icons.edit,
                                  onTap: () {
                                    Navigator.pushNamed(context, "/form",
                                        arguments: items[index]["id"]);
                                  },
                                ),
                              ],
                              secondaryActions: <Widget>[
                                IconSlideAction(
                                  caption: "done",
                                  color: Colors.lime,
                                  icon: Icons.check,
                                  onTap: () async {
                                    // Databaseoperation()
                                    //     .changebool(items[index]["id"], 1);
                                    await LocalDatabase()
                                        .boolchange(items[index]["id"], true);
                                    // Notificationoperation().notification();
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    );
                  } else {
                    return Center(
                      child: Text("todo???????????????????????????"),
                    );
                  }
                } else {
                  if (snapshot.hasData && items.length != 0) {
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return RaisedButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 1.0, horizontal: 0),
                          elevation: 3.0,
                          onPressed: () {
                            Navigator.pushNamed(context, "/detail",
                                arguments: items[index]["id"]);
                          },
                          child: Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.25,
                            child: Container(
                              color: Colors.white,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.indigoAccent,
                                  child: Text(''),
                                  foregroundColor: Colors.white,
                                ),
                                title: Text(
                                  "???????????????${items[index]['title']}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                subtitle: Text(
                                    // "???????????????${items[index]['date']} ${items[index]['time']}"),
                                    items[index]["date"] != null
                                        ? "???????????????${datetimeformat.format(DateTime.parse(items[index]["date"]).add(Duration(hours: 9)))}"
                                        : ""),
                              ),
                            ),
                            actions: <Widget>[
                              IconSlideAction(
                                caption: "delete",
                                color: Colors.red,
                                icon: Icons.delete,
                                onTap: () async {
                                  // Databaseoperation()
                                  //     .delete(items[index]["id"]);
                                  await LocalDatabase()
                                      .deleteData(items[index]["id"]);
                                  setState(() {});
                                },
                              ),
                              IconSlideAction(
                                caption: "edit",
                                color: Colors.yellow,
                                icon: Icons.edit,
                                onTap: () {
                                  Navigator.pushNamed(context, "/form",
                                      arguments: items[index]["id"]);
                                },
                              ),
                            ],
                            secondaryActions: <Widget>[
                              IconSlideAction(
                                caption: "canceal",
                                color: Colors.blue,
                                icon: Icons.cancel,
                                onTap: () async {
                                  // Databaseoperation()
                                  //     .changebool(items[index]["id"], 0);
                                  await LocalDatabase()
                                      .boolchange(items[index]["id"], false);
                                  // Notificationoperation().notification();
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text("todo???????????????????????????"),
                    );
                  }
                }
              }),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, "/form", arguments: "");
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.wifi),
              title: Text("do"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.done),
              title: Text("done"),
            )
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
        ));
  }
}
