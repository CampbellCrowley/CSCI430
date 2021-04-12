import 'dart:convert';

import 'package:design_and_prototype/main.dart';
import 'package:design_and_prototype/models/db.dart';
import 'package:design_and_prototype/models/device_model.dart';
import 'package:design_and_prototype/setup/add_device.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddDevice()))
              .then((value) => setState(() {
                    devices = DatabaseService().getDevices();
                  }));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Setup'),
        actions: [],
      ),
      body: FutureBuilder<dynamic>(
          future: devices,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      GridView(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            childAspectRatio: 2.0,
                            mainAxisSpacing: 5),
                        children: [
                          for (var i in snapshot.data
                              .where((i) => i.location == null)
                              .toList()) ...[
                            Card(
                                elevation: 10,
                                child: InkWell(
                                  onTap: () {},
                                  child: GridTile(
                                    header: Container(
                                        padding: EdgeInsets.only(top: 3),
                                        height: 25,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[800]
                                                .withOpacity(0.6)),
                                        child: Text(
                                          "Setup Device",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey[100],
                                              fontWeight: FontWeight.w700),
                                        )),
                                    child: Icon(
                                      Icons.warning,
                                      color: Colors.yellow,
                                    ),
                                    footer: Container(
                                        padding: EdgeInsets.only(top: 3),
                                        height: 25,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[800]
                                                .withOpacity(0.6)),
                                        child: Text(
                                          "${i.id}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey[100]),
                                        )),
                                  ),
                                ))
                          ]
                        ],
                      )
                    ],
                  ),
                  // if (deviceSelected) ...[
                  //   Text(
                  //     "(${x_pos.toStringAsPrecision(5)}, ${y_pos.toStringAsPrecision(5)})",
                  //     style: TextStyle(fontSize: 20),
                  //   ),
                  //   GestureDetector(
                  //     onTapDown: (TapDownDetails x) {
                  //       print(x.globalPosition);
                  //       setState(() {
                  //         x_pos = x.localPosition.dx;
                  //         y_pos = x.localPosition.dy;
                  //       });
                  //     },
                  //     child: Stack(
                  //       children: [
                  //         Container(
                  //           child: Center(child: Image.asset('assets/map-floor-4.gif')),
                  //         ),
                  //         Positioned(
                  //             left: x_pos,
                  //             top: y_pos,
                  //             child: Container(
                  //               height: 30,
                  //               width: 30,
                  //               decoration: BoxDecoration(
                  //                   shape: BoxShape.circle, color: Colors.black),
                  //             ))
                  //       ],
                  //     ),
                  //   ),
                  //   ElevatedButton(
                  //       onPressed: () {
                  //         print("Send data");
                  //       },
                  //       child: Text('Send')),
                  // ],
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "Current Devices",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ListView(
                        physics: ClampingScrollPhysics(),
                        itemExtent: 125,
                        shrinkWrap: true,
                        // itemCount: snapshot.data.length,
                        // itemBuilder: (context, index) {
                        // Device d = snapshot.data[index];
                        children: [
                          for (var d in snapshot.data
                              .where((d) => d.location != null)
                              .toList()) ...[
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Card(
                                elevation: 6,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DeviceDetails(
                                                  device: d,
                                                ))).then((value) =>
                                        setState(() {
                                          devices =
                                              DatabaseService().getDevices();
                                        }));
                                  },
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Container(
                                          width: 40,
                                          child: Column(
                                            children: [
                                              Text(
                                                'Floor',
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              Text(
                                                '${d.location['alt']}',
                                                style: TextStyle(fontSize: 70),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 125,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                65,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                width: 200,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text('ID: ${d.id}'),
                                                    Text(
                                                        'Avg. Volume: ${d.level['volume']}'),
                                                  ],
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.bottomLeft,
                                                child: NoiseMeter(
                                                    averageVolume: d
                                                        .level['volume']
                                                        .toDouble()),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ]
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 125,
                  )
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            ;
          }),
    );
  }
}
