import 'dart:async';
import 'package:flutter/material.dart';
import 'package:twodayrule/habit.dart';

class HabitCard extends StatefulWidget {

  final Habit habit;
  final StreamController<void> habitStreamController;
  final Function removeHabit;
  HabitCard({this.habit, this.habitStreamController, this.removeHabit});

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
        return Colors.green[200];
      case 1:
        return Colors.orange[200];
      case 2:
        return Colors.red[200];
      default:
        return Colors.white;
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
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[850],
                  ),
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => widget.removeHabit(context.widget),
                    ),
                    Checkbox(
                      value: checkboxTicked,
                      activeColor: Colors.grey[850],
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
            )
          ],
        ),
      ),
    );
  }
}
