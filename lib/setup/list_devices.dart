import 'dart:convert';

import 'package:design_and_prototype/models/db.dart';
import 'package:design_and_prototype/models/device_model.dart';
import 'package:design_and_prototype/setup/device_details.dart';
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

  bool deviceSelected = false;
  @override
  void initState() {
    super.initState();
    devices = DatabaseService().getDevices();
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
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          Device d = snapshot.data[index];
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DeviceDetails(
                                              device: d,
                                            ))).then((value) => setState(() {
                                      devices = DatabaseService().getDevices();
                                    }));
                              },
                              child: ListTile(
                                title: Text(d.name),
                                subtitle: Text('Volume: ${d.level['volume']}'),
                              ),
                            ),
                          );
                        });
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            )
          ]
        ],
      ),
    );
  }
}
