import 'dart:convert';

import 'package:design_and_prototype/models/device_model.dart';
import 'package:design_and_prototype/models/floor_model.dart';
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

      // REMOVE DEVICES THAT HAVE NOT BEEN SETUP
      List<Device> filtered = list.where((i) => i.location != null).toList();

      // SORT BY FLOOR
      filtered.sort((a, b) => a.location['alt'].compareTo(b.location['alt']));

      List floors = [];
      int highestFloor = filtered.last.location['alt'];
      for (var i = 1; i < highestFloor + 1; i++) {
        floors.add(filtered.where((x) => x.location['alt'] == i).toList());
      }

      for (var i = 0; i < floors.length; i++) {
        Floor f;
        var result =
            floors[i].map((d) => d.level['volume']).reduce((a, b) => a + b) /
                floors[i].length;
        print(result);
        f = Floor(
            altitude: (i + 1).toString(),
            averageVolume: result,
            numberOfDevices: floors[i].length);
        floors[i] = f;
      }

      print(floors);
      return floors.reversed.toList();
    } else {
      var x = jsonDecode(response.body);
      throw Exception('${x['error']}');
    }
  }

  Future<http.Response> setupDevice(
      String id, String username, int lat, int lon, int alt) async {
    var response = await http.post(
      Uri.https('hush.campbellcrowley.com', 'api/setup-device'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
        'username': username,
        'lat': lat,
        'lon': lon,
        'alt': alt,
      }),
    );
    print(response.body);
    return response;
  }

  Future<http.Response> deleteDevice(String id, String username) async {
    print(id);
    var response = await http.delete(
      Uri.https('hush.campbellcrowley.com', 'api/delete-device'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
        'username': username,
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
