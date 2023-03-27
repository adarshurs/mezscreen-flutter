import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mezcreen/models/room.dart';
import 'package:mezcreen/ui/screens/room_screen.dart';
import '../../base/constants/env.dart';
import '../../base/constants/sampleData.dart';
import '../../base/constants/utils.dart';
import '../../view_model/database_helper.dart';
import '../dialogs/add_room_dialog.dart';
import '../widgets/custom_card.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/homeScreen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Hello Mateo,",
          style:
              Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 24),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Image.asset(
                "assets/images/dummy_person.png",
                width: 50,
                height: 50,
              ),
              onPressed: () {
                HelperParsing.testParsing();
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            WeatherInfoWidget(),
            Padding(
              padding: EdgeInsets.only(top: 21.29),
              child: EnergySavingInfoWidget(),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 21.29),
                child: RoomsListWidget(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

///////////////////////////////////////////////
///////////////////////////////////////////////
//// FIND WIDGETS USED IN THIS FILE BELOW /////
///////////////////////////////////////////////
///////////////////////////////////////////////

class WeatherInfoWidget extends StatelessWidget {
  const WeatherInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's Weather",
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: const Color(0XFF494949), fontSize: 15),
        ),
        Row(
          children: [
            const Icon(
              Icons.cloud,
              color: Colors.black,
              size: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.63),
              child: Text(
                "14°C",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontSize: 18),
              ),
            )
          ],
        )
      ],
    );
  }
}

class EnergySavingInfoWidget extends StatelessWidget {
  const EnergySavingInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Energy Saving",
          style:
              Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 9.65),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              EnergySavingInfoTile(
                tileIcon: Icons.power,
                tileTitle: 'Today',
                tileText: "93KWh",
              ),
              EnergySavingInfoTile(
                tileIcon: Icons.flash_on,
                tileTitle: 'This Week',
                tileText: "970,244kWh",
              ),
            ],
          ),
        )
      ],
    );
  }
}

class EnergySavingInfoTile extends StatelessWidget {
  final IconData tileIcon;
  final String tileTitle;
  final String tileText;
  const EnergySavingInfoTile(
      {super.key,
      required this.tileIcon,
      required this.tileTitle,
      required this.tileText});

  @override
  Widget build(BuildContext context) {
    return CustomClickableCard(
      height: 65.98,
      //width of this tile is (fullScreenWidth - ((padding to the size(L&R) (18 * 2) ) + (padding between the tiles (10)))) / 2 (number of tiles in a row)
      width: (MediaQuery.of(context).size.width - 46) / 2,
      childWidget: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(7.22, 0, 10.8, 0),
            child: CircleAvatar(
              radius: 16.785,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                tileIcon,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tileTitle,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: const Color(0XFFB1B0B0), fontSize: 12),
              ),
              Text(tileText,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 15)),
            ],
          )
        ],
      ),
    );
  }
}

class RoomsListWidget extends StatelessWidget {
  const RoomsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Rooms",
          style:
              Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: _roomStreamBuilder(),
        )
      ],
    );
  }

  StreamBuilder _roomStreamBuilder() {
    return StreamBuilder<DatabaseEvent>(
        stream: FirebaseDatabase.instance.ref().child(rootNode).onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Widget> children = <Widget>[];
            Map<dynamic, dynamic> rooms =
                snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            AddRoomTile.numberOfRooms = 0;
            rooms.forEach((key, value) {
              Map<dynamic, dynamic> devices =
                  value["devices"] as Map<dynamic, dynamic>;
              AddRoomTile.numberOfRooms++;
              children.add(RoomTile(
                roomIcon: roomTypeIcons[key.toString()] ?? Icons.bed,
                roomTitle: value["name"],
                roomText: "${devices.length} Devices",
                onTap: () {
                  Navigator.of(context).pushNamed(RoomScreen.routeName,
                      arguments: {
                        'roomName': value["name"],
                        'roomKey': key.toString()
                      });
                },
                onLongPress: () {
                  DatabaseHelper.instance.removeRoom(key.toString());
                },
              ));
            });
            children.add(const AddRoomTile());
            return GridView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
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

class RoomTile extends StatelessWidget {
  final IconData roomIcon;
  final String roomTitle;
  final String roomText;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  const RoomTile(
      {super.key,
      required this.roomIcon,
      required this.roomTitle,
      required this.roomText,
      required this.onTap,
      required this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return CustomClickableCard(
        onTap: onTap,
        onLongPress: onLongPress,
        childWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 16.785,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                roomIcon,
                color: Theme.of(context).colorScheme.background,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 11.11, 0, 2.89),
              child: Text(
                roomTitle,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 15),
              ),
            ),
            Text(roomText,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: const Color(0XFFB1B0B0), fontSize: 12)),
          ],
        ));
  }
}

class AddRoomTile extends StatelessWidget {
  static int numberOfRooms = 0;

  const AddRoomTile({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomClickableCard(
      bgColor: const Color(0XFFF5F5F5),
      onTap: () {
        AddRoomDialog().show(context);
      },
      enableBoxShadow: false,
      childWidget: Icon(
        Icons.add_circle_outline_rounded,
        color: Theme.of(context).colorScheme.primary,
        //),
      ),
    );
  }
}
