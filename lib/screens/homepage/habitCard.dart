import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twodayrule/bloc/blocs.dart';
import 'package:twodayrule/screens/details_screen/detailsScreen.dart';

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
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => DetailsBloc()..add(DetailsLoaded(habit)),
                    child: DetailsScreen(),
                  ),
                ));
          },
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      habit.task,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[850],
                      ),
                    ),
                    SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Current streak: ${habit.currentStreak}"),
                        SizedBox(width: 30),
                        Text("Longest streak: ${habit.longestStreak}"),
                      ],
                    ),
                  ],
                ),
                Transform.scale(
                  scale: 1.6,
                  child: Checkbox(
                    value: habit.complete,
                    activeColor: Colors.grey[850],
                    onChanged: (bool value) {
                      BlocProvider.of<HabitBloc>(context)
                          .add(HabitUpdated(habit.copyWith(complete: value)));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
