import 'package:design_and_prototype/floor_heatmap.dart';
import 'package:design_and_prototype/models/db.dart';
import 'package:design_and_prototype/setup/list_devices.dart';
import 'package:flutter/material.dart';
import 'package:design_and_prototype/models/floor_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hush',
      theme: ThemeData(
          primarySwatch: Colors.red,
          accentColor: Color(0xff8C2332),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.grey[600],
          primaryColor: Color(0xff8C2332),
          cardColor: Color(0xff2C2A29)),
      home: MyHomePage(title: 'Hush'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<dynamic> floors;

  @override
  void initState() {
    super.initState();
    floors = DatabaseService().getFloors();
  }

  @override
  Widget build(BuildContext context) {
    var bd = BoxDecoration(
      boxShadow: [
        BoxShadow(
            color: Colors.black54,
            blurRadius: 15.0,
            spreadRadius: 1.0,
            offset: Offset(0.1, 0.1))
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/quiet.png',
              height: 55,
              color: Colors.white,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              widget.title,
              style: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 2),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Setup()))
                  .then((value) => setState(() {
                        floors = DatabaseService().getFloors();
                      }));
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: FutureBuilder<dynamic>(
                future: floors,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          Floor f = snapshot.data[index];
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Card(
                              elevation: 6,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FloorHeatmap(
                                                floor: f.altitude,
                                              ))).then((value) => setState(() {
                                        floors = DatabaseService().getFloors();
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
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                            Text(
                                              '${f.altitude}',
                                              style: TextStyle(fontSize: 70),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 125,
                                      width: MediaQuery.of(context).size.width -
                                          65,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    'Avg. Volume: ${f.averageVolume}'),
                                                f.numberOfDevices == 1
                                                    ? Text(
                                                        '${f.numberOfDevices} device')
                                                    : Text(
                                                        '${f.numberOfDevices} devices')
                                              ],
                                            ),
                                            Align(
                                              alignment: Alignment.bottomLeft,
                                              child: NoiseMeter(
                                                  averageVolume:
                                                      f.averageVolume),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: null,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ),
    );
  }
}

class NoiseMeter extends StatelessWidget {
  final double averageVolume;
  NoiseMeter({Key key, this.averageVolume}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: 20,
            width: 4,
            color: Colors.green,
          ),
          SizedBox(
            width: 2,
          ),
          (averageVolume.floor() >= 2)
              ? Container(
                  height: 30,
                  width: 4,
                  color: Colors.green[300],
                )
              : Container(
                  height: 30,
                  width: 4,
                  color: Colors.grey[900],
                ),
          SizedBox(
            width: 2,
          ),
          (averageVolume.floor() >= 3)
              ? Container(
                  height: 40,
                  width: 4,
                  color: Colors.green[200],
                )
              : Container(
                  height: 40,
                  width: 4,
                  color: Colors.grey[900],
                ),
          SizedBox(
            width: 2,
          ),
          (averageVolume.floor() >= 4)
              ? Container(
                  height: 50,
                  width: 4,
                  color: Colors.yellow[200],
                )
              : Container(
                  height: 50,
                  width: 4,
                  color: Colors.grey[900],
                ),
          SizedBox(
            width: 2,
          ),
          (averageVolume.floor() >= 5)
              ? Container(
                  height: 60,
                  width: 4,
                  color: Colors.yellow[300],
                )
              : Container(
                  height: 60,
                  width: 4,
                  color: Colors.grey[900],
                ),
          SizedBox(
            width: 2,
          ),
          (averageVolume.floor() >= 6)
              ? Container(
                  height: 70,
                  width: 4,
                  color: Colors.orange[200],
                )
              : Container(
                  height: 70,
                  width: 4,
                  color: Colors.grey[900],
                ),
          SizedBox(
            width: 2,
          ),
          (averageVolume.floor() >= 7)
              ? Container(
                  height: 80,
                  width: 4,
                  color: Colors.orange[300],
                )
              : Container(
                  height: 80,
                  width: 4,
                  color: Colors.grey[900],
                ),
          SizedBox(
            width: 2,
          ),
          (averageVolume.floor() >= 8)
              ? Container(
                  height: 90,
                  width: 4,
                  color: Colors.red[200],
                )
              : Container(
                  height: 90,
                  width: 4,
                  color: Colors.grey[900],
                ),
          SizedBox(
            width: 2,
          ),
          (averageVolume.floor() >= 9)
              ? Container(
                  height: 100,
                  width: 4,
                  color: Colors.red[400],
                )
              : Container(
                  height: 100,
                  width: 4,
                  color: Colors.grey[900],
                ),
        ],
      ),
    );
  }
}
