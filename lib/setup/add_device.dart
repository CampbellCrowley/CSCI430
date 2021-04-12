import 'package:design_and_prototype/models/db.dart';
import 'package:flutter/material.dart';

class AddDevice extends StatefulWidget {
  AddDevice({Key key}) : super(key: key);

  @override
  _AddDeviceState createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> {
  final _formKey = GlobalKey<FormState>();
  final idController = TextEditingController();
  final volumeController = TextEditingController();
  String id = '';
  int volume = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //     "Device ID",
            //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  focusColor: Colors.grey[300],
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  border: OutlineInputBorder(borderSide: BorderSide()),
                  labelText: 'Device ID',
                ),
                controller: idController,
                onChanged: (value) => setState(() {
                  id = value;
                }),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  focusColor: Colors.grey[300],
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  border: OutlineInputBorder(borderSide: BorderSide()),
                  labelText: 'Volume',
                ),
                controller: volumeController,
                onChanged: (value) => setState(() {
                  volume = int.parse(value);
                }),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
            ),
            ElevatedButton(
                onPressed: () => DatabaseService().updateDevice(id, volume),
                child: Text('Add'))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    idController.dispose();
    volumeController.dispose();
    super.dispose();
  }
}
