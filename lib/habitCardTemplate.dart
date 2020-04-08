import 'package:flutter/material.dart';
import 'package:twodayrule/habit.dart';

class HabitCardTemplate extends StatefulWidget {

  final Habit habit;

  HabitCardTemplate({this.habit});

  @override
  _HabitCardTemplateState createState() => _HabitCardTemplateState();
}

class _HabitCardTemplateState extends State<HabitCardTemplate> {
  bool checkboxTicked = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  widget.habit.habitName,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Checkbox(
                  value: checkboxTicked,
                  onChanged: (bool value) {
                    setState(() {
                      checkboxTicked = value;
                    });
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
