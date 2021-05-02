import 'package:cached_network_image/cached_network_image.dart';
import 'package:design_and_prototype/models/db.dart';
import 'package:design_and_prototype/models/device_model.dart';
import 'package:design_and_prototype/models/floor_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FloorHeatmap extends StatefulWidget {
  const FloorHeatmap({Key key, this.floor}) : super(key: key);
  final Floor floor;

  @override
  _FloorHeatmapState createState() => _FloorHeatmapState();
}

class _FloorHeatmapState extends State<FloorHeatmap> {
  Future<List<Device>> devices;
  @override
  void initState() {
    super.initState();

    getDevicesOnFloor();
  }

  getDevicesOnFloor() {
    setState(() {
      devices = DatabaseService().getDevicesOnFloor(4);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Floor ${widget.floor.altitude}'),
          actions: [],
        ),
        body: FutureBuilder<List<Device>>(
            future: devices,
            builder: (context, snapshot) {
              List<Device> device = snapshot.data;
              return Column(
                children: [
                  if (snapshot.hasData) ...[
                    Container(
                      height: 75,
                      child: Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            scrollDirection: Axis.horizontal,
                            // padding: const EdgeInsets.all(8.0),
                            itemBuilder: (context, index) {
                              return Container(
                                width: 85,
                                child: Card(
                                  elevation: 6,
                                  child: Column(
                                    children: [
                                      Text('D${index + 1}',
                                          style: TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.w600)),
                                      Text(
                                          'Volume: ${device[index].level['volume']}')
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ] else ...[
                    Container(
                      height: 75,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  ],
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Center(
                            child: CachedNetworkImage(
                          // height: 500,
                          width: 375,
                          imageUrl:
                              "https://library.csuchico.edu/sites/default/files/map-floor-${widget.floor.altitude}.gif",
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Container(
                            height: 500,
                            width: 375,
                            child: Center(
                              child: CircularProgressIndicator(
                                  value: downloadProgress.progress),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        )),
                        if (snapshot.hasData)
                          for (var d in device)
                            Positioned(
                                left: d.location['lat'].toDouble() - 12.5,
                                top: d.location['lon'].toDouble() - 6.25,
                                child: SpinKitDoubleBounce(
                                  color: Colors.red,
                                  // duration: Duration(milliseconds: 1000),
                                  size: 25.0,
                                )),
                        if (snapshot.hasData)
                          for (var i = 0; i < device.length; i++)
                            Positioned(
                                left:
                                    device[i].location['lat'].toDouble() - 12.5,
                                top:
                                    device[i].location['lon'].toDouble() - 6.25,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xff2C2A29),
                                    shape: BoxShape.circle,
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //       color: Colors.red,
                                    //       blurRadius: 25.0,
                                    //       spreadRadius: 40.0,
                                    //       offset: Offset(0.1, 0.1))
                                    // ],
                                  ),
                                  height: 25,
                                  width: 25,
                                  child: Center(
                                    child: Text(
                                      'D${i + 1}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ))
                        // Padding(
                        //   padding: const EdgeInsets.only(
                        //     left: 120.0,
                        //   ),
                        //   child: Center(
                        //     child: Container(
                        //       height: 1,
                        //       width: 1,
                        // decoration: BoxDecoration(
                        //   color: Colors.red,
                        //   shape: BoxShape.circle,
                        //   boxShadow: [
                        //     BoxShadow(
                        //         color: Colors.red,
                        //         blurRadius: 25.0,
                        //         spreadRadius: 40.0,
                        //         offset: Offset(0.1, 0.1))
                        //   ],
                        // ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
