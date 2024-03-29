import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twoday/common/constants.dart';
import 'package:twoday/cubit/habit_cubit.dart';
import 'package:twoday/cubit/habit_details_cubit.dart';
import 'package:twoday/screens/details_screen/detailsScreen.dart';

class HabitCard extends StatefulWidget {
  final String id;

  HabitCard({this.id});

  @override
  _HabitCardState createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  Color cardStyleDaysSinceLastDone(int daysSinceLastDone) {
    switch (daysSinceLastDone) {
      case 0:
        return kGreen;
      case 1:
        return kYellow;
      case 2:
        return kRed;
      default:
        return kWhite;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitCubit, HabitState>(
        builder: (BuildContext context, HabitState state) {
      final habit = (state as HabitsLoaded)
          .habits
          .firstWhere((habit) => habit.id == widget.id, orElse: () => null);
      return Card(
        color: cardStyleDaysSinceLastDone(habit.daysSinceLastDone),
        margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                      create: (context) =>
                          HabitDetailsCubit()..getQuarterlyStatisticsOfHabit(widget.id),
                      child: DetailsScreen(id: widget.id)),
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
                          color: kOnWhite),
                    ),
                    SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Current streak: ${habit.currentStreak}",
                          style: TextStyle(color: kOnWhite),
                        ),
                        SizedBox(width: 30),
                        Text(
                          "Longest streak: ${habit.longestStreak}",
                          style: TextStyle(color: kOnWhite),
                        ),
                      ],
                    ),
                  ],
                ),
                Transform.scale(
                  scale: 1.6,
                  child: Theme(
                    data: ThemeData(unselectedWidgetColor: kOnWhite),
                    child: Checkbox(
                      value: habit.done,
                      activeColor: kOnWhite,
                      onChanged: (bool value) {
                        BlocProvider.of<HabitCubit>(context).toggleHabitEntry(
                            habitId: habit.id,
                            value: value,
                            dateTime: DateTime.now());
                      },
                    ),
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
