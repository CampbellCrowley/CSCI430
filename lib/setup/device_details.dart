import 'package:design_and_prototype/models/db.dart';
import 'package:design_and_prototype/models/device_model.dart';
import 'package:design_and_prototype/setup/setup_device.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DeviceDetails extends StatefulWidget {
  final Device device;
  DeviceDetails({Key key, @required this.device}) : super(key: key);

  @override
  _DeviceDetailsState createState() => _DeviceDetailsState();
}

class _DeviceDetailsState extends State<DeviceDetails> {
  void _onItemTapped(int index) async {
    print(index);
    if (index == 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SetupDevice(
                    device: widget.device,
                  )));
    } else {
      _showMyDialog(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    Device d = widget.device;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey[300],
        selectedItemColor:
            d.location != null ? Colors.grey[300] : Colors.yellow,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: d.location != null
                ? Icon(Icons.settings_input_antenna_sharp)
                : Icon(Icons.warning),
            label: 'Setup',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.volume_up),
            label: 'Update Volume',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delete),
            label: 'Delete',
          ),
        ],
        // currentIndex: _selectedIndex,
        // selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(d.name),
            Text(
              'Setup',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey),
            )
          ],
        ),
        actions: [],
      ),
      // bottomSheet: Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: [
      //     ElevatedButton(
      //         onPressed: () {
      //           DatabaseService().setupDevice(d.id, 'clayton', 10, 9, 2);
      //         },
      //         child: Text('Setup Device')),
      //     ElevatedButton(
      //         onPressed: () {
      //           DatabaseService().updateDevice(d.id, 2);
      //         },
      //         child: Text('Update Device')),
      //     ElevatedButton(
      //         onPressed: () {
      //           DatabaseService().deleteDevice(d.id, 'clayton');
      //         },
      //         child: Text('Delete')),
      //   ],
      // ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(d.name),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Level',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(d.level['id']),
                Text(d.level['volume'].toString()),
                Text(DateTime.fromMillisecondsSinceEpoch(d.level['timestamp'])
                    .toString()),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                d.location != null
                    ? Text('Latitude: ${d.location['lat']}')
                    : Text('Latitude: No info'),
                d.location != null
                    ? Text('Longitude: ${d.location['lon']}')
                    : Text('Longitude: No info'),
                d.location != null
                    ? Text('Altitude: ${d.location['alt']}')
                    : Text('Altitude: No info'),
                d.location != null
                    ? Text('Accuracy: ${d.location['accuracy']}')
                    : Text('Accuracy: No info'),
                d.location != null
                    ? Text('Name: ${d.location['name']}')
                    : Text('Name: No info'),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  void showSnack(BuildContext context, String r) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(r),
      ),
    );
  }

  Future<void> _showMyDialog(int index) async {
    String title = '';
    String body = '';
    if (index == 0) {
      title = "Setup";
    }
    if (index == 1) {
      title = "Update volume?";
      body = "Select volume to set.";
    }
    if (index == 2) {
      title = "Delete Device?";
      body =
          "Are you sure you want to delete this device?\nThis can't be undone.";
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(body),
              ],
            ),
          ),
          actions: <Widget>[
            if (index == 1)
              Column(
                children: [
                  Row(
                    children: [
                      FlatButton(
                          color: Colors.green[300],
                          textColor: Colors.black,
                          onPressed: () async {
                            var r = await DatabaseService()
                                .updateDevice(widget.device.id, 2);
                            Navigator.of(context).pop();
                            showSnack(
                                context, r.body.toString() + 'Volume set to 2');
                          },
                          child: Text('2')),
                      SizedBox(
                        width: 3,
                      ),
                      FlatButton(
                          color: Colors.yellow[200],
                          textColor: Colors.black,
                          onPressed: () async {
                            var r = await DatabaseService()
                                .updateDevice(widget.device.id, 4);
                            Navigator.of(context).pop();
                            showSnack(
                                context, r.body.toString() + 'Volume set to 4');
                          },
                          child: Text('4')),
                      SizedBox(
                        width: 3,
                      ),
                      FlatButton(
                          color: Colors.orange[200],
                          textColor: Colors.black,
                          onPressed: () async {
                            var r = await DatabaseService()
                                .updateDevice(widget.device.id, 6);
                            Navigator.of(context).pop();
                            showSnack(
                                context, r.body.toString() + 'Volume set to 6');
                          },
                          child: Text('6')),
                    ],
                  ),
                  Row(
                    children: [
                      FlatButton(
                          color: Colors.red[200],
                          textColor: Colors.black,
                          onPressed: () async {
                            var r = await DatabaseService()
                                .updateDevice(widget.device.id, 8);
                            Navigator.of(context).pop();
                            showSnack(
                                context, r.body.toString() + 'Volume set to 8');
                          },
                          child: Text('8')),
                      SizedBox(
                        width: 3,
                      ),
                      FlatButton(
                          color: Colors.red[400],
                          textColor: Colors.black,
                          onPressed: () async {
                            var r = await DatabaseService()
                                .updateDevice(widget.device.id, 10);
                            Navigator.of(context).pop();
                            showSnack(context,
                                r.body.toString() + 'Volume set to 10');
                          },
                          child: Text('10'))
                    ],
                  ),
                ],
              ),
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel')),
            if (index != 1)
              TextButton(
                child: Text('Yes',
                    style: TextStyle(
                        color: Colors.green[600], fontWeight: FontWeight.w600)),
                onPressed: () async {
                  if (index == 0) {
                    showSnack(context,
                        "device_details.dart: This should not have happened");
                  }
                  if (index == 2) {
                    var r =
                        await DatabaseService().deleteDevice(widget.device.id);
                    Navigator.of(context).pop();
                    showSnack(context, r.body.toString());
                    Navigator.of(context).pop();
                  }
                },
              ),
          ],
        );
      },
    );
  }
}
