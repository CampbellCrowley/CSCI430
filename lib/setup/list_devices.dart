import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:design_and_prototype/auth/google_login.dart';
import 'package:design_and_prototype/main.dart';
import 'package:design_and_prototype/models/db.dart';
import 'package:design_and_prototype/models/device_model.dart';
import 'package:design_and_prototype/setup/add_device.dart';
import 'package:design_and_prototype/setup/device_details.dart';
import 'package:design_and_prototype/setup/setup_device.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';

class ListDevices extends StatefulWidget {
  const ListDevices({Key key}) : super(key: key);

  @override
  _ListDevicesState createState() => _ListDevicesState();
}

class _ListDevicesState extends State<ListDevices> {
  double x_pos = 0.0;
  double y_pos = 0.0;
  Future<dynamic> devices;

  bool deviceSelected = false;
  bool isSignedIn = false;

  void _isSignedIn() async {
    bool response = await googleSignIn.isSignedIn();
    setState(() {
      isSignedIn = response;
    });
  }

  PackageInfo packageInfo;
  void getPackageInfo() async {
    PackageInfo x = await PackageInfo.fromPlatform();
    setState(() {
      packageInfo = x;
    });
  }

  @override
  void initState() {
    super.initState();
    devices = DatabaseService().getDevices();
    _isSignedIn();
    getPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: isSignedIn
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddDevice()))
                    .then((value) => setState(() {
                          devices = DatabaseService().getDevices();
                        }));
              },
              child: Icon(Icons.add),
            )
          : Text(''),
      appBar: AppBar(
        title: Text('Info'),
        actions: [
          isSignedIn
              ? FlatButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    // await googleSignIn.disconnect();
                    await googleSignIn.signOut();
                    setState(() {
                      isSignedIn = false;
                    });
                  },
                  child: Text('Logout'))
              : Text('')
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.active) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            User user = snapshot.data;
            if (user == null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CachedNetworkImage(
                          imageUrl:
                              'https://www.csuchico.edu/aaspace/_assets/set-up-documents/mlib/meriam.jpg',
                          imageBuilder: (context, imageProvider) => Container(
                            width: 100.0,
                            height: 100.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Meriam Library",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff8C2332)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Located in',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, bottom: 12.0, top: 5.0),
                          child: Text(
                            'California State University, Chico',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          'Address',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, bottom: 12.0, top: 5.0),
                          child: Text(
                            '400 W 1st St, Chico, CA 95929',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          'Phone',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, bottom: 12.0, top: 5.0),
                          child: Text(
                            '(530) 898-6501',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  packageInfo != null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Version: ${packageInfo.version}',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                'Build: ${packageInfo.buildNumber}',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        )
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      Divider(
                        thickness: 2,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, bottom: 5.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Administrator login",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff8C2332)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              primary: Colors.black,
                              backgroundColor: Colors.black,
                              padding: EdgeInsets.all(8)),
                          // color: Colors.white,
                          // splashColor: Colors.grey,
                          onPressed: () {
                            try {
                              signInWithGoogle().then((result) {
                                if (result != null) {
                                  print("Signed in with Google.");
                                  setState(() {
                                    isSignedIn = true;
                                  });
                                } else {
                                  print(
                                      'An error occured or sign in was canceled');
                                }
                              });
                            } catch (error) {
                              print(error);
                            }
                          },
                          child: Container(
                            height: 40,
                            width: double.infinity,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset('assets/google_logo.png',
                                    height: 28.0),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Text(
                                    'Sign in with Google',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      )
                    ],
                  ),
                ],
              );
            } else {
              return FutureBuilder<dynamic>(
                  future: devices,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var devicesToSetup = snapshot.data
                          .where((i) =>
                              i.location == null || i.location['alt'] == null)
                          .toList();
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "Setup Devices",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              GridView(
                                physics: ClampingScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 5,
                                        childAspectRatio: 2.0,
                                        mainAxisSpacing: 5),
                                children: [
                                  if (devicesToSetup.length == 0)
                                    Card(
                                        elevation: 10,
                                        child: GridTile(
                                          header: Container(
                                              padding: EdgeInsets.only(top: 3),
                                              height: 25,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[800]
                                                      .withOpacity(0.6)),
                                              child: Text(
                                                "No devices pending setup",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[100],
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )),
                                          child: Icon(
                                            Icons.check,
                                            color: Colors.green,
                                          ),
                                          footer: Container(
                                              padding: EdgeInsets.only(top: 3),
                                              height: 25,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[800]
                                                      .withOpacity(0.6)),
                                              child: Text(
                                                "...",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[100]),
                                              )),
                                        )),
                                  for (var i in devicesToSetup) ...[
                                    Card(
                                        elevation: 10,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SetupDevice(
                                                              device: i,
                                                            )))
                                                .then((value) => setState(() {
                                                      devices =
                                                          DatabaseService()
                                                              .getDevices();
                                                    }));
                                          },
                                          child: GridTile(
                                            header: Container(
                                                padding:
                                                    EdgeInsets.only(top: 3),
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
                                                      fontWeight:
                                                          FontWeight.w700),
                                                )),
                                            child: Icon(
                                              Icons.warning,
                                              color: Colors.yellow,
                                            ),
                                            footer: Container(
                                                padding:
                                                    EdgeInsets.only(top: 3),
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
                              ),
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
                                      .where((d) =>
                                          d.location != null &&
                                          d.location['alt'] != null)
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
                                                        builder: (context) =>
                                                            DeviceDetails(
                                                              device: d,
                                                            )))
                                                .then((value) => setState(() {
                                                      devices =
                                                          DatabaseService()
                                                              .getDevices();
                                                    }));
                                          },
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0),
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
                                                        style: TextStyle(
                                                            fontSize: 70),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 125,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    65,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Container(
                                                        width: 200,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text('ID: ${d.id}'),
                                                            Text(
                                                                'Avg. Volume: ${d.level['volume']}'),
                                                          ],
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .bottomLeft,
                                                        child: NoiseMeter(
                                                            averageVolume: d.level[
                                                                        'volume']
                                                                    is String
                                                                ? double.parse(d
                                                                        .level[
                                                                    'volume'])
                                                                : d.level[
                                                                        'volume']
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
                  });
            }
          }),
    );
  }
}
