import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twoday/common/constants.dart';
import 'package:twoday/cubit/habit_cubit.dart';
import 'package:twoday/models/habit.dart';
import 'package:twoday/screens/homepage/habitCard.dart';
import 'package:twoday/screens/homepage/modalBottomSheet.dart';

class HabitList extends StatefulWidget {
  @override
  _HabitListState createState() => _HabitListState();
}

class _HabitListState extends State<HabitList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
              context: context,
              builder: (context) => ModalBottomSheet(),
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          backgroundColor: kTransparent,
          elevation: 0,
          flexibleSpace: Padding(
              padding: EdgeInsets.only(top: 60, left: 20),
              child: Text(
                "Habits",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: kOnBackground),
              )),
        ),
      ),
      body: BlocBuilder<HabitCubit, HabitState>(
        builder: (BuildContext context, HabitState state) {
          if (state is HabitsLoaded) {
            return buildHabitList(state.habits);
          } else if (state is HabitsLoading) {
            return buildLoadingIndicator();
          } else {
            return buildErrorMessage(state);
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }

  Widget buildErrorMessage(HabitState state) =>
      Center(child: Text((state as HabitsError).exceptionMessage));

  Widget buildLoadingIndicator() => Center(child: CircularProgressIndicator());

  Widget buildHabitList(List<Habit> habits) {
    if (habits.length > 0) {
      return RefreshIndicator(
        onRefresh: () => BlocProvider.of<HabitCubit>(context).getAllHabits(),
        child: ListView.builder(
          padding: EdgeInsets.only(bottom: 20),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: habits.length,
          itemBuilder: (context, index) {
            final habit = habits[index];
            return Dismissible(
              key: Key(habit.id),
              onDismissed: (direction) =>
                  BlocProvider.of<HabitCubit>(context).deleteHabit(habit),
              child: HabitCard(
                id: habit.id,
              ),
              confirmDismiss: (direction) async {
                return await confirmHabitDelete(context);
              },
            );
          },
        ),
      );
    } else {
      return Padding(
          padding: EdgeInsets.only(top: 10, left: 20),
          child: Text("Tap the + sign to add your first habit",
              style: TextStyle(fontSize: 16, color: kOnBackground)));
    }
  }

  Future<bool> confirmHabitDelete(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Confirm deletion of habit?",
            style: TextStyle(color: kOnBackground),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    "CANCEL",
                    style: TextStyle(color: kOnBackground),
                  )),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(
                    "DELETE",
                    style: TextStyle(
                      color: kOnBackground,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: kRed,
                    padding: EdgeInsets.only(left: 20, right: 20),
                  )),
            ],
          ),
        );
      },
    );
  }
}
