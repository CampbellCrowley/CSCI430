class Device {
  final String id;
  final String name;
  final Map level;
  final Map location;

  Device({this.id, this.name, this.level, this.location});

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] as String,
      name: json['name'] as String,
      level: json['level'] as Map,
      location: json['location'] as Map,
    );
  }
}
