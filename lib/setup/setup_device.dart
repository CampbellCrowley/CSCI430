import 'dart:convert';

import 'package:design_and_prototype/models/db.dart';
import 'package:design_and_prototype/models/device_model.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SetupDevice extends StatefulWidget {
  final Device device;
  SetupDevice({Key key, @required this.device}) : super(key: key);

  @override
  _SetupDeviceState createState() => _SetupDeviceState();
}

class _SetupDeviceState extends State<SetupDevice> {
  List devices;
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  String id = '';
  int volume = 0;
  int floor = 1;
  double lat = 150.0;
  double lon = 150.0;
  String name = "";

  void getDevicesPerFloor() async {
    List _devices = await DatabaseService().getDevices();
    setState(() {
      devices = _devices;
    });
    devices
        .where((i) =>
            i.location != null &&
            i.location['alt'] != null &&
            i.location['alt'] == floor)
        .length;
  }

  @override
  void initState() {
    super.initState();
    getDevicesPerFloor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name),
        actions: [],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Set Location",
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Color(0xff8C2332)),
                ),
                Text(
                  "Set floor and floor coordinates for device.",
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 3,
            endIndent: 250,
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Floor",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () => setState(() {
                  final newValue = floor - 1;
                  floor = newValue.clamp(1, 4);
                }),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5),
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: NumberPicker(
                    value: floor,
                    minValue: 1,
                    maxValue: 4,
                    step: 1,
                    itemHeight: 50,
                    itemWidth: 75,
                    axis: Axis.horizontal,
                    onChanged: (value) => setState(() => floor = value),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black26),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => setState(() {
                  final newValue = floor + 1;
                  floor = newValue.clamp(1, 4);
                }),
              ),
            ],
          ),
          if (devices != null) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Current # of Devices: ${devices.where((i) => i.location != null && i.location['alt'] != null && i.location['alt'] == floor).length}',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Coordinates",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Text(
                  "(${lat.toStringAsPrecision(6)}, ${lon.toStringAsPrecision(6)})",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTapDown: (TapDownDetails x) {
                    print(x.globalPosition);
                    setState(() {
                      lat = x.localPosition.dx;
                      lon = x.localPosition.dy;
                    });
                  },
                  child: devices != null
                      ? Stack(
                          children: [
                            Container(
                              child: Center(
                                  child: CachedNetworkImage(
                                // height: 500,
                                width: 375,
                                imageUrl:
                                    "https://library.csuchico.edu/sites/default/files/map-floor-$floor.gif",
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        Container(
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
                            ),
                            for (var i in devices
                                .where((i) =>
                                    i.location != null &&
                                    i.location['alt'] != null &&
                                    i.location['alt'] == floor)
                                .toList()) ...[
                              Positioned(
                                  left: i.location['lat'].toDouble() - 12.5,
                                  top: i.location['lon'].toDouble() - 6.25,
                                  child: SpinKitDoubleBounce(
                                    color: Colors.red,
                                    size: 25.0,
                                  ))
                            ],
                            Positioned(
                                left: lat - 25,
                                top: lon - 12.5,
                                child: Image.asset(
                                  'assets/esp8266.png',
                                  width: 50,
                                ))
                          ],
                        )
                      : Text(''),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SpinKitDoubleBounce(
                        color: Colors.red,
                        size: 25.0,
                      ),
                      Text(' = existing device'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Divider(
                  thickness: 6,
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Set Name & Volume",
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Color(0xff8C2332)),
                  ),
                ),
                Divider(
                  thickness: 3,
                  endIndent: 250,
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Name",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      focusColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff8C2332))),
                      border: OutlineInputBorder(borderSide: BorderSide()),
                      labelText: 'Ex. \'Northside 3rd floor\'',
                    ),
                    controller: nameController,
                    onChanged: (value) => setState(() {
                      name = value;
                    }),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a name for the device.';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Initial Volume",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () => setState(() {
                        final newValue = volume - 1;
                        volume = newValue.clamp(0, 10);
                      }),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: NumberPicker(
                          value: volume,
                          minValue: 0,
                          maxValue: 10,
                          step: 1,
                          itemHeight: 50,
                          itemWidth: 75,
                          axis: Axis.horizontal,
                          onChanged: (value) => setState(() => volume = value),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.black26),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => setState(() {
                        final newValue = volume + 1;
                        volume = newValue.clamp(0, 10);
                      }),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 150,
                        height: 50,
                        child: ElevatedButton.icon(
                          label: Text('Cancel'),
                          icon: Icon(Icons.cancel),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey[500],
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      Container(
                        width: 150,
                        height: 50,
                        child: ElevatedButton.icon(
                            label: Text('Submit'),
                            icon: Icon(Icons.check_box),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green[500],
                            ),
                            onPressed: () async {
                              var r = await DatabaseService().setupDevice(
                                  widget.device.id, name, lat, lon, floor);
                              if (r.statusCode != 200)
                                showSnack(context,
                                    'ERROR: ${json.decode(r.body)['error']}');
                              else {
                                if (r.statusCode == 201)
                                  showSnack(context,
                                      "${json.decode(r.body)['message']}");
                                else if (r.statusCode == 200)
                                  showSnack(context,
                                      "${json.decode(r.body)['message']}");
                              }
                            }),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showSnack(BuildContext context, String r) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 6),
        content: Text(r),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    super.dispose();
  }
}
