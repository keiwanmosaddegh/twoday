import 'package:flutter/material.dart';

class ModalBottomSheet extends StatefulWidget {
  @override
  _ModalBottomSheetState createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      margin: EdgeInsets.fromLTRB(26, 16, 12, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          HabitTextField(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                child: Text(
                  "Save",
                  style: TextStyle(
                    color: Colors.blue
                  ),
                ),
                onPressed: () {},
              ),
            ],
          )
        ],
      ),
    );
  }
}

class HabitTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          hintText: "New habit",
          border: InputBorder.none,
          hintStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.grey[500])),
    );
  }
}

class SaveHabitButton extends StatefulWidget {
  @override
  _SaveHabitButtonState createState() => _SaveHabitButtonState();
}

class _SaveHabitButtonState extends State<SaveHabitButton> {
  bool checkingFlight = false;
  bool success = false;

  @override
  Widget build(BuildContext context) {
    return !checkingFlight
        ? MaterialButton(
            onPressed: () async {
              setState(() {
                checkingFlight = true;
              });

              Navigator.pop(context);
            },
            child: Text("Save", style: TextStyle(color: Colors.black)),
          )
        : !success
            ? CircularProgressIndicator()
            : Icon(
                Icons.check,
                color: Colors.green,
              );
  }
}
