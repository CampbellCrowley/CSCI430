import 'package:design_and_prototype/models/db.dart';
import 'package:design_and_prototype/models/device_model.dart';
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
    if (index == 0)
      DatabaseService().setupDevice(widget.device.id, 'clayton', 10, 9, 2);
    if (index == 1) {
      var r = await DatabaseService().updateDevice(widget.device.id, 2);
      showSnack(context, r.body.toString());
    }
    if (index == 2) {
      var r = await DatabaseService().deleteDevice(widget.device.id, 'clayton');
      showSnack(context, r.body.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Device d = widget.device;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_input_antenna_sharp),
            label: 'Configure',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.update),
            label: 'Update',
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
      //         child: Text('Configure Device')),
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
}
