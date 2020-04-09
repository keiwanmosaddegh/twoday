import 'dart:async';
import 'package:flutter/material.dart';
import 'package:twodayrule/habit.dart';

class HabitCard extends StatefulWidget {

  final Habit habit;
  final StreamController<void> habitStreamController;
  HabitCard({this.habit, this.habitStreamController});

  @override
  _HabitCardState createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  bool checkboxTicked = false;
  int daysSinceLastCheckboxTick = 4;
  int previousDaysSinceLastCheckboxTick = 0;

  @override
  void initState() {
    super.initState();
    widget.habitStreamController.stream.listen((_) {
      uncheckCheckbox();
    });
  }

  void uncheckCheckbox() {
    setState(() {
      checkboxTicked = false;
      daysSinceLastCheckboxTick++;
    });
  }

  Color cardStyleDaysSinceLastCheck() {
    switch(daysSinceLastCheckboxTick) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.red;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardStyleDaysSinceLastCheck(),
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
                      if(checkboxTicked) {
                        previousDaysSinceLastCheckboxTick = daysSinceLastCheckboxTick;
                        daysSinceLastCheckboxTick = 0;
                      } else {
                        daysSinceLastCheckboxTick = previousDaysSinceLastCheckboxTick;
                      }
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
