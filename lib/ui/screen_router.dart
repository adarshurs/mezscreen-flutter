import 'package:flutter/material.dart';
import 'package:mezcreen/ui/screens/home_screen.dart';
import 'package:mezcreen/ui/screens/room_screen.dart';

var screenRoutes = <String, WidgetBuilder>{
  HomeScreen.routeName: (context) => const HomeScreen(),
  RoomScreen.routeName: (context) => const RoomScreen(),
};
