import 'dart:convert';

import 'package:design_and_prototype/models/device_model.dart';
import 'package:design_and_prototype/models/floor_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class DatabaseService {
  Future<List<Device>> getDevices() async {
    final response =
        await http.get(Uri.https('hush.campbellcrowley.com', 'api/get-data'));
    if (response.statusCode == 200) {
      var r = jsonDecode(response.body)['data']['devices'];
      final parsed = r.cast<Map<String, dynamic>>();
      List<Device> list =
          parsed.map<Device>((json) => Device.fromJson(json)).toList();

      return list;
    } else {
      var x = jsonDecode(response.body);
      throw Exception('${x['error']}');
    }
  }

  Future<List<dynamic>> getFloors() async {
    final response =
        await http.get(Uri.https('hush.campbellcrowley.com', 'api/get-data'));
    if (response.statusCode == 200) {
      var r = jsonDecode(response.body)['data']['devices'];
      final parsed = r.cast<Map<String, dynamic>>();
      List<Device> list =
          parsed.map<Device>((json) => Device.fromJson(json)).toList();
      // REMOVE DEVICES THAT HAVE NOT BEEN SETUP (location list is null)
      List<Device> filtered = list.where((i) => i.location != null).toList();
      // REMOVE DEVICES THAT HAVE NOT BEEN SETUP (alt is null)
      filtered = filtered.where((i) => i.location['alt'] != null).toList();
      // SORT BY FLOOR
      filtered.sort((a, b) => a.location['alt'].compareTo(b.location['alt']));

      List floors = [];
      List allDevices = [];
      int highestFloor = filtered.last.location['alt'];
      for (var i = 1; i < highestFloor + 1; i++) {
        List filter_device_floors =
            filtered.where((device) => device.location['alt'] == i).toList();
        if (filter_device_floors.isNotEmpty) {
          floors.add(filter_device_floors);
          allDevices.addAll(filter_device_floors);
        }
      }

      print(allDevices.toString());

      for (var i = 0; i < floors.length; i++) {
        Floor f;
        var result = floors[i]
                .map((d) => d.level['volume'] is String
                    ? double.parse(d.level['volume'])
                    : d.level['volume'])
                .reduce((a, b) => a + b) /
            floors[i].length;
        f = Floor(
            altitude: (floors[i][0].location['alt']).toString(),
            averageVolume: result,
            numberOfDevices: floors[i].length);
        floors[i] = f;
      }

      return floors.reversed.toList();
    } else {
      var x = jsonDecode(response.body);
      throw Exception('${x['error']}');
    }
  }

  Future<List<Device>> getDevicesOnFloor(int floor) async {
    final response =
        await http.get(Uri.https('hush.campbellcrowley.com', 'api/get-data'));
    if (response.statusCode == 200) {
      var r = jsonDecode(response.body)['data']['devices'];
      final parsed = r.cast<Map<String, dynamic>>();
      List<Device> list =
          parsed.map<Device>((json) => Device.fromJson(json)).toList();
      // REMOVE DEVICES THAT HAVE NOT BEEN SETUP (location list is null)
      List<Device> filtered = list.where((i) => i.location != null).toList();
      // REMOVE DEVICES THAT HAVE NOT BEEN SETUP (alt is null)
      filtered = filtered.where((i) => i.location['alt'] != null).toList();

      // FILTER FOR FLOOR THAT IS REQUESTED
      filtered = filtered.where((i) => i.location['alt'] == floor).toList();
      // // SORT BY FLOOR
      // filtered.sort((a, b) => a.location['alt'].compareTo(b.location['alt']));

      // List floors = [];
      // List allDevices = [];
      // int highestFloor = filtered.last.location['alt'];
      // for (var i = 1; i < highestFloor + 1; i++) {
      //   List filter_device_floors =
      //       filtered.where((device) => device.location['alt'] == i).toList();
      //   if (filter_device_floors.isNotEmpty) {
      //     floors.add(filter_device_floors);
      //     allDevices.addAll(filter_device_floors);
      //   }
      // }

      // print(allDevices.toString());

      return filtered.toList();
    } else {
      var x = jsonDecode(response.body);
      throw Exception('${x['error']}');
    }
  }

  Future<http.Response> setupDevice(String id, String name, String username,
      double lat, double lon, int alt) async {
    User user = FirebaseAuth.instance.currentUser;
    String token = await user.getIdToken(true);

    var response = await http.post(
      Uri.https('hush.campbellcrowley.com', 'api/setup-device'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
        'token': token.toString(),
        'lat': lat,
        'lon': lon,
        'alt': alt,
        'accuracy': 1,
        'name': name,
      }),
    );
    return response;
  }

  Future<http.Response> deleteDevice(String id, String username) async {
    User user = FirebaseAuth.instance.currentUser;
    String token = await user.getIdToken(true);
    var response = await http.delete(
      Uri.https('hush.campbellcrowley.com', 'api/delete-device'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
        'token': token,
      }),
    );
    print(response.body);
    return response;
  }

  Future<http.Response> updateDevice(String id, int volume) async {
    print(id);
    var response = await http.post(
      Uri.https('hush.campbellcrowley.com', 'api/update-data'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
        'volume': volume,
      }),
    );
    print(response.body);
    return response;
  }
}
