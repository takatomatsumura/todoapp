import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'package:todoapp/operation.dart';
import 'package:provider/provider.dart';

class CountData extends ChangeNotifier {
  int count = 0;

  void increment() {
    count++;
    notifyListeners();
  }
}

class Data extends StatelessWidget {
  final data = CountData();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CountData>.value(
        value: data,
        child: Container(
          child: ChildWidget(),
        ));
  }
}

class ChildWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CountData data = context.watch<CountData>();
    return Column(
      children: <Widget>[
        Text('count is ${data.count.toString()}'),
        RaisedButton(
          child: Text('Increment'),
          onPressed: () {
            data.increment();
          },
        ),
      ],
    );
  }
}

// class Todo {
//   String? title = "create";
//   DateTime? datetime = DateTime.now();
//   bool? donebool = true;

//   Todo(
//     this.title,
//     this.datetime,
//     this.donebool,
//   );
// }

// class Data extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Todo"),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios_sharp),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         actions: [
//           IconButton(
//               icon: Icon(Icons.settings),
//               color: Colors.white,
//               iconSize: 40,
//               onPressed: () {
//                 Navigator.pushNamed(context, "/setting");
//               })
//         ],
//       ),
//       body: _FormPage(title: 'Sample Aplication'),
//     );
//   }
// }

// class _FormPage extends StatefulWidget {
//   _FormPage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   _FormPageState createState() => _FormPageState();
// }

// class _FormPageState extends State<_FormPage> {
//   var data;
//   var jsondata;
//   List userData = [];
//   final dio = Dio();
//   final domain = '10.0.2.2';
//   // final domain = 'localhost';

//   Future post() async {
//     final response = await dio.post(
//       "http://$domain:8000/todo/create",
//       data: {
//         "title": "title",
//         "date": DateTime.now().toString(),
//         "donebool": false,
//         "image": null,
//       },
//       options: Options(
//           // headers: Config().authHeader,
//           ),
//     );
//     data = response.data;
//     print(response);
//     print(data);
//   }

//   @override
//   void initState() {
//     super.initState();
//     // post();
//     LocalDatabase().listlength();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: ListView.builder(
//       // itemCount: userData == null ? 0 : userData.length,
//       itemCount: 1,
//       itemBuilder: (BuildContext context, int index) {
//         return Card(
//           child: Row(
//             children: <Widget>[
//               Text("")
//               // userData[index]["avator"] != null
//               // userData[index]["image"] != null
//               // ? CircleAvatar(
//               //     // backgroundImage: NetworkImage(userData[index]["avator"]),
//               //     child: Text("text"),
//               // )
//               // : Text("title")
//             ],
//           ),
//         );
//       },
//     ));
//   }
// }
