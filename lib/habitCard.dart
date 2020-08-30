import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twodayrule/homepage/bloc/bloc.dart';

class HabitCard extends StatefulWidget {
  final String id;

  HabitCard({this.id});

  @override
  _HabitCardState createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  Color cardStyleDaysSinceLastComplete(int daysSinceLastComplete) {
    switch (daysSinceLastComplete) {
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
    return BlocBuilder<HabitBloc, HabitState>(
        builder: (BuildContext context, HabitState state) {
      final habit = (state as HabitsLoadSuccess)
          .habits
          .firstWhere((habit) => habit.id == widget.id, orElse: () => null);
      return Card(
        color: cardStyleDaysSinceLastComplete(habit.daysSinceLastComplete),
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
                    habit.task,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[850],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Current streak: ${habit.currentStreak}"),
                      SizedBox(height: 6),
                      Text("Longest streak: ${habit.longestStreak}")
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => BlocProvider.of<HabitBloc>(context)
                            .add(HabitDeleted(habit)),
                      ),
                      Checkbox(
                        value: habit.complete,
                        activeColor: Colors.grey[850],
                        onChanged: (bool value) {
                          BlocProvider.of<HabitBloc>(context).add(
                              HabitUpdated(habit.copyWith(complete: value)));
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
    });
  }
}
