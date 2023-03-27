import 'dart:convert';
import '../base/constants/sampleData.dart';
import 'device.dart';

class Room {
  List<Device> devices = [];
  String? name;
  String? key;

  Room({required this.devices, this.name});

  Room.fromJson(String roomKey, Map<String, dynamic> json) {
    key = roomKey;
    name = json['name'];
    devices = HelperParsing.parseDevices(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // if (devices != null) {
    //   data['devices'] = devices.toJson();
    // }
    data['name'] = name;
    return data;
  }
}

class HelperParsing {
  static List<Room> parseRooms(dynamic response) {
    List<Room> roomsList = [];

    // Parsed Json have what's inside data, in case of real request look for the line above this.
    final parsedJson = jsonDecode(json.encode(response));

    // Iterate over all rooms and create Item object from each,
    // then push to a list of Item's objects to return it.
    parsedJson?.forEach((roomKey, fruitDetails) =>
        roomsList.add(Room.fromJson(roomKey, fruitDetails)));

    return roomsList;
  }

  static List<Device> parseDevices(dynamic response) {
    List<Device> devicesList = [];

    // Parsed Json have what's inside data, in case of real request look for the line above this.
    final parsedJson = response['devices'];

    // Iterate over all devices and create Item object from each,
    // then push to a list of Item's objects to return it.
    parsedJson?.forEach((deviceKey, deviceDetails) =>
        devicesList.add(Device.fromJson(deviceKey, deviceDetails)));

    return devicesList;
  }

  static testParsing() async {
    List<Room> foodItemsList = HelperParsing.parseRooms(data);
    for (var element in foodItemsList) {
      print(element.name);
      print(element.key);
      print(element.devices.length);
      for (var device in element.devices) {
        print(device.toString());
      }
    }
  }
}
