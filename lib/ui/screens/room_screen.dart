import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../base/constants/env.dart';
import '../../base/constants/utils.dart';
import '../../view_model/database_helper.dart';
import '../widgets/custom_card.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';

class RoomScreen extends StatefulWidget {
  static const String routeName = "/roomScreen";
  const RoomScreen({super.key});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  late String roomKey;
  late String roomName;

  void _getParameters() {
    try {
      final routes =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      roomKey = routes['roomKey'] ?? "";
      roomName = routes['roomName'] ?? "";
    } catch (e) {
      print("Invalid parameters");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    _getParameters();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        surfaceTintColor: Theme.of(context).colorScheme.background,
        shadowColor: const Color(0x40000000),
        elevation: 5,
        centerTitle: true,
        title: Text(roomName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            AddDeviceTile(
              roomKey: roomKey,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 11.0),
              child: _deviceStreamBuilder(),
            )
          ],
        ),
      ),
    );
  }

  StreamBuilder _deviceStreamBuilder() {
    return StreamBuilder<DatabaseEvent>(
        stream: FirebaseDatabase.instance
            .ref()
            .child("$rootNode/$roomKey/devices")
            .onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Widget> children = <Widget>[];
            Map<dynamic, dynamic> devices =
                snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            devices.forEach((key, value) {
              //print(value.toString());
              children.add(DeviceTile(
                iconData: deviceTypeIcons[value['type'].toString()] ??
                    Icons.lightbulb,
                title: value['name'],
                value: value['value'].toString(),
                type: value['type'].toString(),
                onValueChanged: (value) {
                  DatabaseHelper.instance.updateDevice(
                      roomKey: roomKey, deviceKey: key, value: value);
                },
                // onLongPress: () {
                //   DatabaseHelper.instance.removeDevice(
                //       roomKey: roomKey, deviceKey: key.toString());
                // },
              ));
            });

            return GridView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0 / 0.66, //Width & height ratio
                mainAxisSpacing: 10,
                crossAxisSpacing: 9.53,
              ),
              children: children,
            );
          } else if (snapshot.hasError) {
            return ErrorCustomWidget(errorText: snapshot.error.toString());
          } else {
            return const LoadingWidget();
          }
        });
  }
}

///////////////////////////////////////////////
///////////////////////////////////////////////
//// FIND WIDGETS USED IN THIS FILE BELOW /////
///////////////////////////////////////////////
///////////////////////////////////////////////

class AddDeviceTile extends StatelessWidget {
  final String roomKey;
  const AddDeviceTile({super.key, required this.roomKey});
  @override
  Widget build(BuildContext context) {
    return CustomClickableCard(
      bgColor: const Color(0XFFF5F5F5),
      height: 54.57,
      width: MediaQuery.of(context).size.width,
      onTap: () {
        DatabaseHelper.instance.addDevice(roomKey: roomKey);
      },
      enableBoxShadow: false,
      childWidget: Icon(
        Icons.add_circle_outline_rounded,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class DeviceTile extends StatelessWidget {
  final IconData iconData;
  final String title;
  final String value;
  final String type;
  final Function(String) onValueChanged;
  final VoidCallback? onLongPress;

  const DeviceTile(
      {super.key,
      required this.iconData,
      required this.title,
      required this.value,
      required this.onValueChanged,
      required this.type,
      this.onLongPress});

  bool get _isDeviceOn => (value.toString() == "0") ? false : true;

  Widget _getDeviceController(String deviceType) {
    if (!_isDeviceOn) {
      return const SizedBox(
        height: 20,
      );
    }

    switch (deviceType) {
      case "light":
        return IntensitySlider(
            onValueChanged: onValueChanged, sliderValue: double.parse(value));
      case "fan":
        return ButtonsController(
          onValueChanged: onValueChanged,
          currentValue: int.parse(value),
          maxValue: 3,
        );
      case "ac":
        return ButtonsController(
          onValueChanged: onValueChanged,
          currentValue: int.parse(value),
          maxValue: 35,
        );
      // case "curtain":
      //   return null;
      // case "door":
      //   return null;
      default:
        return const SizedBox(
          height: 20,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomClickableCard(
        //onTap: onTap,
        onLongPress: onLongPress,
        height: 114.07,
        childWidget: Padding(
          padding: const EdgeInsets.fromLTRB(10.27, 12.98, 10.27, 9.48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    iconData,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  CustomSwitch(
                      currentState: _isDeviceOn,
                      onChanged: (state) {
                        String value = (state) ? "1" : "0";
                        onValueChanged.call(value);
                      }),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Text(
                        title,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 15),
                      ),
                    ),
                    Text(value,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color(0XFFB1B0B0), fontSize: 12)),
                  ],
                ),
              ),
              _getDeviceController(type.toString()),
            ],
          ),
        ));
  }
}

class CustomSwitch extends StatefulWidget {
  late bool currentState;
  final Function(bool) onChanged;
  CustomSwitch(
      {super.key, required this.onChanged, required this.currentState});

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24.08,
      width: 32.12,
      child: FittedBox(
        fit: BoxFit.fill,
        child: Switch(
          activeColor: Theme.of(context).colorScheme.primary,
          value: widget.currentState,
          onChanged: (value) {
            setState(() {
              widget.currentState = !widget.currentState;
              widget.onChanged(widget.currentState);
            });
          },
        ),
      ),
    );
  }
}

class IntensitySlider extends StatefulWidget {
  late double sliderValue;
  final Function(String) onValueChanged;
  IntensitySlider(
      {super.key, required this.onValueChanged, required this.sliderValue});

  @override
  State<IntensitySlider> createState() => _IntensitySliderState();
}

class _IntensitySliderState extends State<IntensitySlider> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20.82,
      width: MediaQuery.of(context).size.width,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 20,
          //trackShape: ,
          activeTrackColor: Theme.of(context).colorScheme.primary,
          thumbColor: Colors.transparent,
          thumbShape: SliderComponentShape.noThumb,
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 0.0),
        ),
        child: Slider(
          value: widget.sliderValue,
          max: 100,
          min: 0,
          onChanged: (double value) {
            setState(() {
              var valueIn1Double = double.parse(value.toStringAsFixed(1));
              widget.sliderValue = valueIn1Double;
              widget.onValueChanged(valueIn1Double.toString());
            });
          },
        ),
      ),
    );
  }
}

class ButtonsController extends StatefulWidget {
  late int currentValue;
  final int maxValue;
  final Function(String) onValueChanged;
  ButtonsController(
      {super.key,
      required this.onValueChanged,
      required this.currentValue,
      required this.maxValue});

  @override
  State<ButtonsController> createState() => _ButtonsControllerState();
}

class _ButtonsControllerState extends State<ButtonsController> {
  void increaseCurrentSpeed() {
    widget.currentValue++;
    if (widget.currentValue >= widget.maxValue) {
      widget.currentValue = widget.maxValue;
    }
  }

  void decreaseCurrentSpeed() {
    widget.currentValue--;
    if (widget.currentValue <= 0) {
      widget.currentValue = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (widget.currentValue <= 0)
                  ? Colors.grey
                  : Theme.of(context).colorScheme.primary,
            ),
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: Icon(
                Icons.add,
                size: 15,
                color: (widget.currentValue >= widget.maxValue)
                    ? const Color(0xFFB1B0B0)
                    : Theme.of(context).colorScheme.background,
              ),
              onPressed: () {
                decreaseCurrentSpeed();
                setState(() {
                  widget.onValueChanged(widget.currentValue.toString());
                });
              },
            )),
        Expanded(
            child: Center(
                child: Text(
          "Speed ${widget.currentValue}",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
        ))),
        CircleAvatar(
          radius: 10,
          backgroundColor: (widget.currentValue >= widget.maxValue)
              ? const Color(0xFFF5F5F5)
              : Theme.of(context).colorScheme.primary,
          child: IconButton(
            icon: Icon(
              Icons.add,
              size: 10,
              color: (widget.currentValue >= widget.maxValue)
                  ? const Color(0xFFB1B0B0)
                  : Theme.of(context).colorScheme.background,
            ),
            onPressed: () {
              increaseCurrentSpeed();
              setState(() {
                widget.onValueChanged(widget.currentValue.toString());
              });
            },
          ),
        )
      ],
    );
  }
}

//
// class ACController extends StatefulWidget {
//   const ACController({super.key});
//
//   @override
//   State<ACController> createState() => _ACControllerState();
// }
//
// class _ACControllerState extends State<ACController> {
//   int currentTemp = 14;
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         const CircleAvatar(
//           radius: 10,
//           backgroundColor: Colors.grey,
//           child: Icon(
//             Icons.add,
//             size: 16,
//           ),
//         ),
//         Expanded(child: Center(child: Text("$currentTemp°"))),
//         CircleAvatar(
//           radius: 10,
//           backgroundColor: Theme.of(context).colorScheme.primary,
//           child: const Icon(
//             Icons.add,
//             size: 16,
//           ),
//         )
//       ],
//     );
//   }
// }
