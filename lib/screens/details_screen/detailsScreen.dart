import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

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
        resizeToAvoidBottomInset: false,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStatisticsModule(HabitDetailsLoaded state) {
    final habitDetails = state.habitDetails;

    final items = habitDetails.statistics.entries
        .map((e) => buildQuarterStatisticsForYear(e.value, year: e.key))
        .toList();

    // final items = habitDetails.statistics.values
    //     .map((quarterStatisticsForYear) =>
    //         buildQuarterStatisticsForYear(quarterStatisticsForYear))
    //     .toList();

    return Column(
      children: [
        buildCarouselSlider(items),
        buildTableCalendar(habitDetails),
      ],
    );
  }

  CarouselSlider buildCarouselSlider(List<Widget> items) {
    return CarouselSlider(
      items: items,
      options: CarouselOptions(
        enableInfiniteScroll: false,
        initialPage: 0,
        aspectRatio: 3 / 1,
        viewportFraction: 1,
        reverse: true,
      ),
    );
  }

  Widget buildQuarterStatisticsForYear(
      Map<String, int> quarterStatisticsForYear,
      {@required int year}) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 22),
            child: Text(
              "Statistics of $year",
              style: TextStyle(fontSize: 16, color: kOnWhite),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildQuarterStatistics(
                  quarter: 1, amount: quarterStatisticsForYear["q1"]),
              buildQuarterStatistics(
                  quarter: 2, amount: quarterStatisticsForYear["q2"]),
              buildQuarterStatistics(
                  quarter: 3, amount: quarterStatisticsForYear["q3"]),
              buildQuarterStatistics(
                  quarter: 4, amount: quarterStatisticsForYear["q4"]),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildQuarterStatistics({@required int quarter, @required int amount}) {
    return Column(
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

  Widget buildTableCalendar(HabitDetails habitDetails) {
    return Card(
      child: TableCalendar(
        onDayLongPressed: (day, events, holidays) async {
          await BlocProvider.of<HabitDetailsCubit>(context).toggleHabitEntry( 
            habitId: habitDetails.habitId,
            value: events?.isEmpty ?? true,
            dateTime: day,
          );
        },
        builders: CalendarBuilders(
          dayBuilder: (context, date, events) {
            if (events?.isNotEmpty ?? false) {
              var currentDateTime = DateTime.parse(
                  DateFormat('yyyy-MM-dd').format(DateTime.now()));
              if (date.difference(currentDateTime).inDays <= 0) {
                return Card(
                  color: kGreen,
                  child: Center(
                    child: Text("${date.day}"),
                  ),
                );
              }
              return Card(
                color: Colors.green[50],
                child: Center(
                  child: Text("${date.day}"),
                ),
              );
            }
            return Card(
              child: Center(
                child: Text("${date.day}"),
              ),
            );
          },
          todayDayBuilder: (context, date, events) {
            if (events?.isNotEmpty ?? false) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: BorderSide(
                    color: Colors.green[300],
                    width: 3,
                  ),
                ),
                color: kGreen,
                child: Center(
                  child: Text(
                    "${date.day}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: BorderSide(
                  color: Colors.grey[300],
                  width: 3,
                ),
              ),
              child: Center(
                child: Text(
                  "${date.day}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
          singleMarkerBuilder: (context, date, event) => SizedBox.shrink(),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: kOnWhite),
          weekendStyle: TextStyle(color: kOnWhite),
        ),
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
        ),
        calendarController: _calendarController,
        startingDayOfWeek: StartingDayOfWeek.monday,
        headerStyle:
            HeaderStyle(formatButtonVisible: false, centerHeaderTitle: true),
        events: Map.fromIterable(habitDetails.entries,
            key: (e) => e, value: (e) => [true]),
      ),
    );
  }
}
