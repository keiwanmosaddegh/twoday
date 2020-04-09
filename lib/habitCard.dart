import 'package:flutter/material.dart';
import 'package:twodayrule/habit.dart';

class HabitCard extends StatefulWidget {

  final Habit habit;

  HabitCard({this.habit});

  @override
  _HabitCardState createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  bool checkboxTicked = false;

  void uncheckTickbox() {
    checkboxTicked = false;
  }

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
                      if(checkboxTicked) {
                        widget.habit.addCheckboxTickDate(DateTime.now());
                      } else {
                        widget.habit.removeCheckboxTickDate();
                      }

                      //skapa en metod i habitList som skickas in i denna klass
                      //den är till för att
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
