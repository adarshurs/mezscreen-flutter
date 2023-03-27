import 'package:flutter/material.dart';
import 'package:mezcreen/base/constants/utils.dart';
import 'package:mezcreen/view_model/database_helper.dart';
import '../screens/home_screen.dart';

class AddRoomDialog {
  Future<void> show(BuildContext context) async {
    return await showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            icon: CircleAvatar(
                radius: 25,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  Icons.bed,
                  color: Theme.of(context).colorScheme.primary,
                )),
            title: Text(
              "Add new device",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(
                    "Name",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 20),
                    child: DialogTextField(
                      //initialText: room['name'],
                      onValueChanged: (String value) {
                        //textFieldValue = value;
                      },
                    ),
                  ),
                  Text(
                    "Type",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 8, 0, 20),
                    child: DropDownMenu(),
                  ),
                  FilledButton(
                      onPressed: () {
                        DatabaseHelper.instance
                            .addRoom(AddRoomTile.numberOfRooms);
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Add",
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 17, 0, 0),
                    child: TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.delete_outline,
                        size: 24.0,
                        color: Colors.red,
                      ),
                      label: Text(
                        'Delete',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.red),
                      ), // <-- Text
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class DialogTextField extends StatefulWidget {
  final ValueChanged<String> onValueChanged;
  final String? initialText;
  const DialogTextField({
    super.key,
    required this.onValueChanged,
    this.initialText,
  });

  @override
  State<StatefulWidget> createState() => _DialogTextFieldState();
}

class _DialogTextFieldState extends State<DialogTextField> {
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    if (widget.initialText != null) {
      textController.text = widget.initialText!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: widget.onValueChanged,
      controller: textController,
      keyboardType: TextInputType.text,
      autocorrect: false,
      autofocus: true,
      maxLines: 1,
      decoration: InputDecoration(
          constraints: const BoxConstraints.tightFor(height: 46),
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0XFFB1B0B0), width: 1),
              borderRadius: BorderRadius.circular(8.0)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0XFFB1B0B0), width: 1),
              borderRadius: BorderRadius.circular(8.0)),
          hintText: "Name",
          hintStyle: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: const Color(0XFFB1B0B0))),
    );
  }
}

class DropDownMenu extends StatefulWidget {
  const DropDownMenu({super.key});

  @override
  State<StatefulWidget> createState() => _DropDownMenuState();
}

class _DropDownMenuState extends State<DropDownMenu> {
  late List<String> _roomTypeOptions = [];
  String selectedValue = "";

  @override
  void initState() {
    super.initState();
    _roomTypeOptions = roomTypes.values.toList();
    _roomTypeOptions.insert(0, "Select your room type");
    selectedValue = _roomTypeOptions.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: const ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
              width: 1.0, color: Color(0XFFB1B0B0), style: BorderStyle.solid),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 10, 0),
        child: DropdownButton<String>(
          itemHeight: 50,
          isExpanded: true,
          value: selectedValue,
          items: _roomTypeOptions.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }).toList(),
          icon: Icon(
            Icons.arrow_drop_down,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          elevation: 0,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18),
          underline: Container(
            height: 0,
            color: Colors.transparent,
          ),
          onChanged: (String? value) {
            setState(() {
              selectedValue = value!;
            });
          },
        ),
      ),
    );
  }
}
