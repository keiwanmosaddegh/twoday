import 'package:flutter/material.dart';
import 'package:twodayrule/habit.dart';

class HabitCardTemplate extends StatefulWidget {

  final Habit habit;
  final Function addCheckboxTickDate;
  final Function removeCheckboxTickDate;

  HabitCardTemplate({this.habit, this.addCheckboxTickDate, this.removeCheckboxTickDate});

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
                      //populera Habit med ett datum i sin stack
                      //gör detta genom att skicka in en metod till denna klass från habit
                      if(checkboxTicked) {
                        widget.addCheckboxTickDate();
                      } else {
                        widget.removeCheckboxTickDate();
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
