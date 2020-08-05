import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'homepage/model/habit.dart';
import 'homepage/bloc/habit_bloc.dart';
import 'homepage/bloc/habit_event.dart';
import 'homepage/bloc/bloc.dart';

class ModalBottomSheet extends StatefulWidget {
  final Function addHabit;
  ModalBottomSheet({this.addHabit});

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
                    BlocProvider.of<HabitBloc>(context).add(HabitAdded(Habit(newHabitController.text)));
                    Navigator.pop(context);
                  }
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