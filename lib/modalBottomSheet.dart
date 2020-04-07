import 'package:flutter/material.dart';

class ModalBottomSheet extends StatefulWidget {
  @override
  _ModalBottomSheetState createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {

  final newHabitController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    newHabitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.fromLTRB(26, 16, 12, 8),
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            HabitTextField(newHabitController: newHabitController),
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
                  onPressed: () {
                    print(newHabitController.text);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class HabitTextField extends StatelessWidget {

  final TextEditingController newHabitController;
  HabitTextField({this.newHabitController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: newHabitController,
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