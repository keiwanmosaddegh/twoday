import 'dart:async';
import 'dart:collection';
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
  int daysSinceLastCheckboxTick = 0;
  ListQueue<DateTime> checkboxHistory = ListQueue();

  @override
  void initState() {
    super.initState();
    widget.habitStreamController.stream.listen((_) {
      uncheckTickbox();

    });
  }

  void uncheckTickbox() {
    setState(() {
      checkboxTicked = false;
    });
  }

  int daysFromToday(DateTime date) {
    return DateTime.now().difference(date).inDays;
  }

  void reactToCheckboxHistory() {
    var daysSinceLastCheckboxTick = daysFromToday(checkboxHistory.first);


  }


  void addCheckboxTickDate(DateTime date) {
    if(checkboxHistory.length > 3) {
      checkboxHistory.removeLast();
    }
    checkboxHistory.addFirst(date);
  }

  void removeCheckboxTickDate() {
    checkboxHistory.removeFirst();
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
                    print("This just triggered lol.");
                    setState(() {
                      checkboxTicked = value;
                      if(checkboxTicked) {
                        addCheckboxTickDate(DateTime.now());
                      } else {
                        removeCheckboxTickDate();
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
