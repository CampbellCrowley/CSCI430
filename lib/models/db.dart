import 'dart:convert';

import 'package:design_and_prototype/models/device_model.dart';
import 'package:http/http.dart' as http;

class DatabaseService {
  Future<List<Device>> getDevices() async {
    final response =
        await http.get(Uri.https('hush.campbellcrowley.com', 'api/get-data'));
    if (response.statusCode == 200) {
      var r = jsonDecode(response.body)['data']['devices'];
      print(r);
      final parsed = r.cast<Map<String, dynamic>>();
      return parsed.map<Device>((json) => Device.fromJson(json)).toList();
      // return Device.fromJson(jsonDecode(response.body)['data']['devices']);
    } else {
      var x = jsonDecode(response.body);
      throw Exception('${x['error']}');
    }
  }

  Future<http.Response> setupDevice(
      String id, String username, int x, int y, int floor) async {
    var response = await http.post(
      Uri.https('hush.campbellcrowley.com', 'api/setup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
        'username': username,
        'x': x,
        'y': y,
        'floor': floor,
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
