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
      devices =
          DatabaseService().getDevicesOnFloor(int.parse(widget.floor.altitude));
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
                      height: 95,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                scrollDirection: Axis.horizontal,
                                // padding: const EdgeInsets.all(8.0),
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: 95,
                                    child: Card(
                                      elevation: 8,
                                      child: Column(
                                        children: [
                                          Text('Device ${index + 1}',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w700)),
                                          VolumeMeter(
                                            averageVolume: device[index]
                                                .level['volume']
                                                .toDouble(),
                                          ),
                                          SizedBox(
                                            height: 4.0,
                                          ),
                                          VolumeToWords(
                                              volume:
                                                  device[index].level['volume'])
                                          // Text(
                                          //     'Volume: ${device[index].level['volume']}')
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
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
                        Container(
                          color: Colors.grey[900],
                          width: 375,
                          height: 400,
                        ),
                        if (snapshot.hasData)
                          for (var i = 0; i < device.length; i++)
                            VolumeHeatMap(
                              volume: device[i].level['volume'],
                              left: device[i].location['lat'].toDouble(),
                              top: device[i].location['lon'].toDouble(),
                              index: i,
                            ),
                        Center(
                          child: Image.asset(
                            'assets/map-floor-${widget.floor.altitude}.gif',
                            width: 375,
                          ),
                        ),
                        if (snapshot.hasData)
                          for (var i = 0; i < device.length; i++)
                            VolumeLabel(
                              volume: device[i].level['volume'],
                              left: device[i].location['lat'].toDouble(),
                              top: device[i].location['lon'].toDouble(),
                              index: i,
                            ),
                        // ColorFiltered(
                        //   colorFilter: ColorFilter.mode(
                        //     Colors.grey,
                        //     BlendMode.saturation,
                        //   ),
                        //   child: Center(
                        //       child: Image.asset(
                        //     'assets/map-floor-4.gif',
                        //     width: 375,
                        //   )
                        //       //     CachedNetworkImage(
                        //       //   // height: 500,
                        //       //   width: 375,
                        //       //   imageUrl:
                        //       //       "https://library.csuchico.edu/sites/default/files/map-floor-${widget.floor.altitude}.gif",
                        //       //   progressIndicatorBuilder:
                        //       //       (context, url, downloadProgress) => Container(
                        //       //     height: 500,
                        //       //     width: 375,
                        //       //     child: Center(
                        //       //       child: CircularProgressIndicator(
                        //       //           value: downloadProgress.progress),
                        //       //     ),
                        //       //   ),
                        //       //   errorWidget: (context, url, error) =>
                        //       //       Icon(Icons.error),
                        //       // )
                        //       ),
                        // ),
                        // if (snapshot.hasData)
                        //   for (var d in device)
                        //     Positioned(
                        //         left: d.location['lat'].toDouble() - 12.5,
                        //         top: d.location['lon'].toDouble() - 6.25,
                        //         child: SpinKitDoubleBounce(
                        //           color: Colors.red,
                        //           // duration: Duration(milliseconds: 1000),
                        //           size: 25.0,
                        //         )),
                        // if (snapshot.hasData)
                        //   for (var i = 0; i < device.length; i++)
                        //     Positioned(
                        //         left:
                        //             device[i].location['lat'].toDouble() - 12.5,
                        //         top:
                        //             device[i].location['lon'].toDouble() - 6.25,
                        //         child: Container(
                        //           decoration: BoxDecoration(
                        //             color: Color(0xff2C2A29),
                        //             shape: BoxShape.circle,
                        //           ),
                        //           height: 25,
                        //           width: 25,
                        //           child: Center(
                        //             child: Text(
                        //               'D${i + 1}',
                        //               style: TextStyle(
                        //                   fontSize: 16,
                        //                   fontWeight: FontWeight.w600),
                        //             ),
                        //           ),
                        //         )),
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

class VolumeHeatMap extends StatelessWidget {
  final int volume;
  final double left;
  final double top;
  final int index;
  const VolumeHeatMap({Key key, this.volume, this.left, this.top, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double left_pos = 28.5;
    double top_pos = 6.25;
    bool very_quiet = false;
    bool quiet = false;
    bool moderate = false;
    bool loud = false;
    bool very_loud = false;

    if (volume <= 2) {
      // left_pos = 35 / 2;
      // top_pos = left_pos / 2;
      very_quiet = true;
    } else if (volume <= 4) {
      // left_pos = 40 / 2;
      // top_pos = left_pos / 2;
      quiet = true;
    } else if (volume <= 6) {
      // left_pos = 45 / 1.4;
      // top_pos = left_pos / 1.5;
      moderate = true;
    } else if (volume <= 8) {
      // left_pos = 50 / 1.35;
      // top_pos = left_pos / 1.45;
      loud = true;
    } else if (volume <= 10) {
      // left_pos = 55 / 2;
      // top_pos = left_pos / 2;
      very_loud = true;
    }
    return Positioned(
        left: left - left_pos,
        top: top - top_pos,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            if (very_loud)
              Container(
                decoration: BoxDecoration(
                  // color: Colors.red[300],
                  shape: BoxShape.circle,
                ),
                height: 35,
                width: 35,
              ),
            if (loud)
              Container(
                decoration: BoxDecoration(
                  color: Colors.orange[900],
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange[900].withOpacity(0.9),
                      spreadRadius: 10,
                      blurRadius: 30,
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                height: 35,
                width: 35,
              ),
            if (moderate)
              Container(
                decoration: BoxDecoration(
                  color: Colors.yellow[200],
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.yellow.withOpacity(0.8),
                      spreadRadius: 10,
                      blurRadius: 30,
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                height: 35,
                width: 35,
              ),
            if (quiet)
              Container(
                decoration: BoxDecoration(
                  color: Colors.green[300],
                  shape: BoxShape.circle,
                ),
                height: 35,
                width: 35,
              ),
            if (very_quiet)
              Container(
                decoration: BoxDecoration(
                  color: Colors.green[200],
                  shape: BoxShape.circle,
                ),
                height: 35,
                width: 35,
              ),
            // Container(
            //   decoration: BoxDecoration(
            //     color: Colors.black,
            //     shape: BoxShape.circle,
            //   ),
            //   height: 25,
            //   width: 25,
            //   child: Center(
            //     child: Text(
            //       'D${index + 1}',
            //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            //     ),
            //   ),
            // ),
          ],
        ));
  }
}

class VolumeLabel extends StatelessWidget {
  final int volume;
  final double left;
  final double top;
  final int index;
  const VolumeLabel({Key key, this.volume, this.left, this.top, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double left_pos = 23.5;
    double top_pos = 1.5;
    bool very_quiet = true;
    bool quiet = false;
    bool moderate = false;
    bool loud = false;
    bool very_loud = false;

    // if (volume >= 2) {
    //   left_pos = 35 / 2;
    //   top_pos = left_pos / 2;
    // }
    // if (volume >= 4) {
    //   left_pos = 40 / 2;
    //   top_pos = left_pos / 2;
    //   quiet = true;
    // }
    // if (volume >= 6) {
    //   left_pos = 45 / 2;
    //   top_pos = left_pos / 2;
    //   moderate = true;
    // }
    // if (volume >= 8) {
    //   left_pos = 50 / 2;
    //   top_pos = left_pos / 2;
    //   loud = true;
    // }
    // if (volume >= 10) {
    //   left_pos = 55 / 2;
    //   top_pos = left_pos / 2;
    //   very_loud = true;
    // }
    return Positioned(
        left: left - left_pos,
        top: top - top_pos,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              height: 25,
              width: 25,
              child: Center(
                child: Text(
                  'D${index + 1}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ));
  }
}

class VolumeToWords extends StatelessWidget {
  final int volume;
  const VolumeToWords({Key key, this.volume}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (volume <= 2) {
      return Text('Very Quiet',
          style: TextStyle(fontSize: 12.0, color: Colors.grey[500]));
    } else if (volume <= 4) {
      return Text('Quiet',
          style: TextStyle(fontSize: 12.0, color: Colors.grey[500]));
    } else if (volume <= 6) {
      return Text('Moderate',
          style: TextStyle(fontSize: 12.0, color: Colors.grey[500]));
    } else if (volume <= 8) {
      return Text('Loud',
          style: TextStyle(fontSize: 12.0, color: Colors.grey[500]));
    } else if (volume <= 10) {
      return Text('Very Loud',
          style: TextStyle(fontSize: 12.0, color: Colors.grey[500]));
    } else {
      return Text('Volume',
          style: TextStyle(fontSize: 12.0, color: Colors.grey[500]));
    }
  }
}

class VolumeMeter extends StatelessWidget {
  final double averageVolume;
  VolumeMeter({Key key, this.averageVolume}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: 5,
            width: 4,
            color: Colors.green,
          ),
          SizedBox(
            width: 2,
          ),
          (averageVolume.floor() >= 2)
              ? Container(
                  height: 10,
                  width: 4,
                  color: Colors.green[300],
                )
              : Container(
                  height: 10,
                  width: 4,
                  color: Colors.grey[900],
                ),
          SizedBox(
            width: 2,
          ),
          (averageVolume.floor() >= 3)
              ? Container(
                  height: 15,
                  width: 4,
                  color: Colors.green[200],
                )
              : Container(
                  height: 15,
                  width: 4,
                  color: Colors.grey[900],
                ),
          SizedBox(
            width: 2,
          ),
          (averageVolume.floor() >= 4)
              ? Container(
                  height: 20,
                  width: 4,
                  color: Colors.yellow[200],
                )
              : Container(
                  height: 20,
                  width: 4,
                  color: Colors.grey[900],
                ),
          SizedBox(
            width: 2,
          ),
          (averageVolume.floor() >= 5)
              ? Container(
                  height: 25,
                  width: 4,
                  color: Colors.yellow[300],
                )
              : Container(
                  height: 25,
                  width: 4,
                  color: Colors.grey[900],
                ),
          SizedBox(
            width: 2,
          ),
          (averageVolume.floor() >= 6)
              ? Container(
                  height: 30,
                  width: 4,
                  color: Colors.orange[200],
                )
              : Container(
                  height: 30,
                  width: 4,
                  color: Colors.grey[900],
                ),
          SizedBox(
            width: 2,
          ),
          (averageVolume.floor() >= 7)
              ? Container(
                  height: 35,
                  width: 4,
                  color: Colors.orange[300],
                )
              : Container(
                  height: 35,
                  width: 4,
                  color: Colors.grey[900],
                ),
          SizedBox(
            width: 2,
          ),
          (averageVolume.floor() > 8)
              ? Container(
                  height: 40,
                  width: 4,
                  color: Colors.red[200],
                )
              : Container(
                  height: 40,
                  width: 4,
                  color: Colors.grey[900],
                ),
          SizedBox(
            width: 2,
          ),
          (averageVolume.floor() >= 9)
              ? Container(
                  height: 45,
                  width: 4,
                  color: Colors.red[400],
                )
              : Container(
                  height: 45,
                  width: 4,
                  color: Colors.grey[900],
                ),
        ],
      ),
    );
  }
}
