import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twodayrule/common/constants.dart';
import 'package:twodayrule/cubit/habit_cubit.dart';
import 'package:twodayrule/cubit/habit_details_cubit.dart';
import 'package:twodayrule/models/habit.dart';

class DetailsScreen extends StatefulWidget {
  final String id;

  DetailsScreen({this.id});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  String _currentTask;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitCubit, HabitState>(
        builder: (BuildContext context, HabitState state) {
      if (state is HabitsLoaded) {
        return buildHabitDetailsScreen(state, context);
      } else if (state is HabitsLoading) {
        return buildHabitDetailsLoadingIndicator();
      } else {
        return buildHabitDetailsErrorMessage(state);
      }
    });
  }

  Widget buildHabitDetailsErrorMessage(dynamic state) {
    if (state is HabitState) {
      return Text((state as HabitsError).exceptionMessage);
    } else if (state is HabitDetailsState) {
      return Text((state as HabitDetailsError).exceptionMessage);
    } else {
      throw ArgumentError.value(state);
    }
  }

  Widget buildHabitDetailsLoadingIndicator() => CircularProgressIndicator();

  Widget buildHabitDetailsScreen(HabitsLoaded state, BuildContext context) {
    final habit = state.habits
        .firstWhere((habit) => habit.id == widget.id, orElse: () => null);
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<HabitCubit>(context)
            .updateHabit(habit.copyWith(task: _currentTask));
        return true;
      },
      child: Scaffold(
        backgroundColor: kBackground,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: kTransparent,
            elevation: 0,
            flexibleSpace: Padding(
              padding: EdgeInsets.only(top: 60, left: 20),
              child: buildHabitNameTextField(habit),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildStatisticsLabel(),
              BlocBuilder<HabitDetailsCubit, HabitDetailsState>(
                builder: (BuildContext context, HabitDetailsState state) {
                  if (state is HabitDetailsLoaded) {
                    return buildStatistics(state);
                  } else if (state is HabitDetailsLoading) {
                    return buildHabitDetailsLoadingIndicator();
                  } else {
                    return buildHabitDetailsErrorMessage(state);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Card buildStatisticsLabel() {
    return Card(
      color: kPrimaryVariant,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 10.0, 10.0, 10.0),
        child: Text(
          "Statistics of ${DateTime.now().year}",
          style: TextStyle(fontSize: 16, color: kOnBackground),
        ),
      ),
    );
  }

  Widget buildStatistics(HabitDetailsLoaded state) {
    final habitDetails = state.habitDetails;
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        children: [
          buildQuarterStatistics(
              quarter: 1, amount: habitDetails.quarterStatistics["q1Count"]),
          buildQuarterStatistics(
              quarter: 2, amount: habitDetails.quarterStatistics["q2Count"]),
          buildQuarterStatistics(
              quarter: 3, amount: habitDetails.quarterStatistics["q3Count"]),
          buildQuarterStatistics(
              quarter: 4, amount: habitDetails.quarterStatistics["q4Count"]),
        ],
      ),
    );
  }

  Widget buildQuarterStatistics({@required int quarter, @required int amount}) {
    return Card(
      color: kOverlay,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 36, 0, 0),
        child: Column(
          children: [
            Text(
              "Quarter $quarter",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: kOnBackground),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "$amount",
              style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  color: kOnBackground),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField buildHabitNameTextField(Habit habit) {
    return TextFormField(
      onChanged: (val) => _currentTask = val,
      initialValue: habit.task,
      cursorColor: kOnBackground,
      decoration: InputDecoration(
        border: InputBorder.none,
      ),
      style: TextStyle(
          fontSize: 30, fontWeight: FontWeight.w600, color: kOnBackground),
    );
  }
}
