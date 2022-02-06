import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twoday/common/constants.dart';
import 'package:twoday/cubit/habit_cubit.dart';
import 'package:twoday/cubit/habit_details_cubit.dart';
import 'package:twoday/models/habit.dart';
import 'package:twoday/models/habitDetails.dart';
import 'package:table_calendar/table_calendar.dart';

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
              BlocBuilder<HabitDetailsCubit, HabitDetailsState>(
                builder: (BuildContext context, HabitDetailsState state) {
                  if (state is HabitDetailsLoaded) {
                    return buildStatisticsModule(state);
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

  Card buildStatisticsLabel(HabitDetails habitDetails) {
    return Card(
      color: kWhite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () async {
              await BlocProvider.of<HabitDetailsCubit>(context).getHabitDetails(
                  habitId: habitDetails.habitId, year: habitDetails.year - 1);
            },
          ),
          Text(
            "Statistics of ${habitDetails.year}",
            style: TextStyle(fontSize: 16, color: kOnWhite),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: () async {
              await BlocProvider.of<HabitDetailsCubit>(context).getHabitDetails(
                  habitId: habitDetails.habitId, year: habitDetails.year + 1);
            },
          ),
        ],
      ),
    );
  }

  Widget buildStatisticsModule(HabitDetailsLoaded state) {
    final habitDetails = state.habitDetails;
    CalendarController calendarController = CalendarController();
    return Column(
      children: [
        buildStatisticsLabel(state.habitDetails),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        Card(
          child: TableCalendar(
            onVisibleDaysChanged: (first, last, format) {
              if (first.year < habitDetails.year) {
                calendarController.nextPage();
              } else if (first.year > habitDetails.year) {
                calendarController.previousPage();
              }
            },
            startDay: DateTime(habitDetails.year, 1, 1),
            endDay: DateTime(habitDetails.year, 12, 31),
            calendarStyle: CalendarStyle(outsideDaysVisible: false),
            calendarController: calendarController,
            startingDayOfWeek: StartingDayOfWeek.monday,
            headerStyle: HeaderStyle(
                formatButtonVisible: false, centerHeaderTitle: true),
          ),
        )
      ],
    );
  }

  Widget buildQuarterStatistics({@required int quarter, @required int amount}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 6, 30, 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Q$quarter",
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w400, color: kOnWhite),
            ),
            Text(
              "$amount",
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w800, color: kOnWhite),
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
