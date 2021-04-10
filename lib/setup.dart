import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Setup extends StatefulWidget {
  const Setup({Key key}) : super(key: key);

  @override
  _SetupState createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  double x_pos = 0.0;
  double y_pos = 0.0;
  Future<dynamic> devices;

  // Future<http.Response> fetchDevices() {
  //   return http.get(Uri.https('hush.campbellcrowley.com', 'api/get-data'));
  // }

  Future<dynamic> fetchDevices() async {
    final response =
        await http.get(Uri.https('hush.campbellcrowley.com', 'api/get-data'));
    print(response.body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      var x = jsonDecode(response.body);
      throw Exception('${x['error']}');
    }
  }

  bool deviceSelected = false;
  @override
  void initState() {
    super.initState();
    devices = fetchDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setup'),
        actions: [],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (deviceSelected) ...[
            Text(
              "(${x_pos.toStringAsPrecision(5)}, ${y_pos.toStringAsPrecision(5)})",
              style: TextStyle(fontSize: 20),
            ),
            GestureDetector(
              onTapDown: (TapDownDetails x) {
                print(x.globalPosition);
                setState(() {
                  x_pos = x.localPosition.dx;
                  y_pos = x.localPosition.dy;
                });
              },
              child: Stack(
                children: [
                  Container(
                    child: Center(child: Image.asset('assets/map-floor-4.gif')),
                  ),
                  Positioned(
                      left: x_pos,
                      top: y_pos,
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.black),
                      ))
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  print("Send data");
                },
                child: Text('Send')),
          ],
          if (!deviceSelected) ...[
            Expanded(
              child: FutureBuilder<dynamic>(
                future: devices,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // return Text(snapshot.data['data']['devices'][0]['name']);
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data['data']['devices'].length,
                        itemBuilder: (context, index) {
                          var device = snapshot.data['data']['devices'][index];
                          return ListTile(
                            title: Text(device['name']),
                            subtitle:
                                Text('Volume: ${device['level']['volume']}'),
                          );
                        });
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return CircularProgressIndicator();
                },
              ),
            )
          ]
        ],
      ),
    );
  }
}

Future<http.Response> deviceSetup(
    String id, String username, int x, int y, int floor) {
  return http.post(
    Uri.https('https://hush.campbellcrowley.com/api/', 'setup'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'id': id,
      'username': username,
      'x': x,
      'y': y,
      'floor': floor,
    }),
  );
}
