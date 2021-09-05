import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/operation.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List items = [];
  int overduelength = 0;
  final datetimeformat = DateFormat('y-M-d HH:mm');

  Future todoitem(int index) async {
    items = await DrfDatabase().getData(index);
    overduelength = await DrfDatabase().listlength();
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
          title: const Text('Todo'),
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
        body: Center(
          child: FutureBuilder(
              future: todoitem(_selectedIndex),
              builder: (context, snapshot) {
                if (_selectedIndex == 0) {
                  if (snapshot.hasData && items.isNotEmpty) {
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        if (index < overduelength) {
                          return Opacity(
                            opacity: 0.5,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(0),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/detail',
                                    arguments: items[index]['id']);
                              },
                              child: Slidable(
                                actionPane: const SlidableDrawerActionPane(),
                                actionExtentRatio: 0.25,
                                child: Container(
                                  color: Colors.white,
                                  child: ListTile(
                                    leading: const CircleAvatar(
                                      backgroundColor: Colors.indigoAccent,
                                      child: Text(''),
                                      foregroundColor: Colors.white,
                                    ),
                                    title: Text(
                                      "タイトル：${items[index]['title']}",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                    subtitle: Text(items[index]['date'] != null
                                        ? '''〆切日時：${datetimeformat.format(DateTime.parse(items[index]['date']).add(const Duration(hours: 9)))}'''
                                        : ''),
                                  ),
                                ),
                                actions: <Widget>[
                                  IconSlideAction(
                                    caption: 'delete',
                                    color: Colors.red,
                                    icon: Icons.delete,
                                    onTap: () async {
                                      await DrfDatabase()
                                          .deleteData(items[index]['id']);
                                      setState(() {});
                                    },
                                  ),
                                  IconSlideAction(
                                    caption: 'edit',
                                    color: Colors.yellow,
                                    icon: Icons.edit,
                                    onTap: () {
                                      Navigator.pushNamed(context, '/form',
                                          arguments: items[index]['id']);
                                    },
                                  ),
                                ],
                                secondaryActions: <Widget>[
                                  IconSlideAction(
                                    caption: 'done',
                                    color: Colors.lime,
                                    icon: Icons.check,
                                    onTap: () async {
                                      await DrfDatabase().boolchange(
                                          items[index]['id'],
                                          boolvalue: true);
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(0),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/detail',
                                  arguments: items[index]['id']);
                            },
                            child: Slidable(
                              actionPane: const SlidableDrawerActionPane(),
                              actionExtentRatio: 0.25,
                              child: Container(
                                color: Colors.white,
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    backgroundColor: Colors.indigoAccent,
                                    child: Text(''),
                                    foregroundColor: Colors.white,
                                  ),
                                  title: Text(
                                    "タイトル：${items[index]['title']}",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  subtitle: Text(items[index]['date'] != null
                                      ? '''〆切日時：${datetimeformat.format(DateTime.parse(items[index]["date"]).add(const Duration(hours: 9)))}'''
                                      : ''),
                                ),
                              ),
                              actions: <Widget>[
                                IconSlideAction(
                                  caption: 'delete',
                                  color: Colors.red,
                                  icon: Icons.delete,
                                  onTap: () async {
                                    await DrfDatabase()
                                        .deleteData(items[index]['id']);
                                    await Notificationoperation()
                                        .notification();
                                    setState(() {});
                                  },
                                ),
                                IconSlideAction(
                                  caption: 'edit',
                                  color: Colors.yellow,
                                  icon: Icons.edit,
                                  onTap: () {
                                    Navigator.pushNamed(context, '/form',
                                        arguments: items[index]['id']);
                                  },
                                ),
                              ],
                              secondaryActions: <Widget>[
                                IconSlideAction(
                                  caption: 'done',
                                  color: Colors.lime,
                                  icon: Icons.check,
                                  onTap: () async {
                                    await DrfDatabase().boolchange(
                                        items[index]['id'],
                                        boolvalue: true);
                                    await Notificationoperation()
                                        .notification();
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
                    return const Center(
                      child: Text('todoリストはありません'),
                    );
                  }
                } else {
                  if (snapshot.hasData && items.isNotEmpty) {
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/detail',
                                arguments: items[index]['id']);
                          },
                          child: Slidable(
                            actionPane: const SlidableDrawerActionPane(),
                            actionExtentRatio: 0.25,
                            child: Container(
                              color: Colors.white,
                              child: ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor: Colors.indigoAccent,
                                  child: Text(''),
                                  foregroundColor: Colors.white,
                                ),
                                title: Text(
                                  "タイトル：${items[index]['title']}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                subtitle: Text(items[index]['date'] != null
                                    ? '''〆切日時：${datetimeformat.format(DateTime.parse(items[index]['date']).add(const Duration(hours: 9)))}'''
                                    : ''),
                              ),
                            ),
                            actions: <Widget>[
                              IconSlideAction(
                                caption: 'delete',
                                color: Colors.red,
                                icon: Icons.delete,
                                onTap: () async {
                                  await DrfDatabase()
                                      .deleteData(items[index]['id']);
                                  setState(() {});
                                },
                              ),
                              IconSlideAction(
                                caption: 'edit',
                                color: Colors.yellow,
                                icon: Icons.edit,
                                onTap: () {
                                  Navigator.pushNamed(context, '/form',
                                      arguments: items[index]['id']);
                                },
                              ),
                            ],
                            secondaryActions: <Widget>[
                              IconSlideAction(
                                caption: 'cancel',
                                color: Colors.blue,
                                icon: Icons.cancel,
                                onTap: () async {
                                  await DrfDatabase().boolchange(
                                      items[index]['id'],
                                      boolvalue: false);
                                  await Notificationoperation().notification();
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('todoリストはありません'),
                    );
                  }
                }
              }),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, '/form', arguments: '');
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.wifi),
              label: 'do',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.done),
              label: 'done',
            )
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
        ));
  }
}
