import 'package:firebase_database/firebase_database.dart';

import '../base/constants/env.dart';

class DatabaseHelper {
  // this is a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  void addRoom(int numberOfRooms) {
    DatabaseReference userRef = FirebaseDatabase.instance.ref().child(rootNode);

    userRef.child("room$numberOfRooms").set({
      "devices": {
        "ac": {"name": "Airconditioner", "type": "ac", "value": 22},
        "curtain": {"name": "Curtain", "type": "curtain", "value": 0},
        "light1": {"name": "Light", "type": "light", "value": 70}
      },
      "name": "Room $numberOfRooms"
    });
  }

  void removeRoom(String roomKey) {
    DatabaseReference userRef = FirebaseDatabase.instance.ref().child(rootNode);
    userRef.child(roomKey).remove().then((value) => print("removed"));
  }

  void addDevice({required String roomKey}) {
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child("$rootNode/$roomKey/devices/");

    userRef
        .child("light4")
        .set({"name": "Light 2", "type": "light", "value": 50}).then(
            (value) => print("added"));
  }

  void updateDevice({
    required String roomKey,
    required String deviceKey,
    required dynamic value,
  }) {
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("$rootNode/$roomKey/devices/$deviceKey");

    userRef.update({
      "value": value.toString(),
    }).then((value2) {
      print("updated");
    });
  }

  void removeDevice({required String roomKey, required String deviceKey}) {
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child("$rootNode/$roomKey/devices/");

    userRef.child(deviceKey).remove().then((value) => print("removed"));
  }
}

// DatabaseReference userRef = FirebaseDatabase
//     .instance
//     .ref()
//     .child("$rootNode/$roomKey/devices/$key");
//
// userRef.update({
//   "value": value.toString(),
// }).then((value2) {
//   print("updated");
// });

// userRef.child("light4").set({
//   "name": "Light 2",
//   "type": "light",
//   "value": 50
// }).then((value) => print("added"));

// userRef
//     .child("kitchen")
//     .remove()
//     .then((value) => print("removed"));

// userRef.child("light4").set({
//   "name": "Light 2",
//   "type": "light",
//   "value": 50
// }).then((value) => print("added"));

// userRef
//     .child("kitchen")
//     .remove()
//     .then((value) => print("removed"));

// userRef
//     .child("room2")
//     .remove()
//     .then((value) => print("removed"));

// userRef.child("light4").set({
//   "name": "Light 2",
//   "type": "light",
//   "value": 50
// }).then((value) => print("added"));

// DatabaseReference userRef =
//     FirebaseDatabase.instance.ref().child(rootNode);
//
// //userRef.child("kitchen").push().set("name:Kitchen");
//
// userRef
//     .child("kitchen")
//     .remove()
//     .then((value) => print("removed"));
