import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twodayrule/habitCard.dart';
import 'package:twodayrule/homepage/model/habit.dart';
import 'package:twodayrule/homepage/bloc/bloc.dart';
import 'package:twodayrule/modalBottomSheet.dart';

class HabitList extends StatefulWidget {
  @override
  _HabitListState createState() => _HabitListState();
}

class _HabitListState extends State<HabitList> {
  List<HabitCard> habitCardList = [];
  StreamController<void> habitStreamController =
      StreamController<void>.broadcast();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
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
              builder: (context) => ModalBottomSheet(addHabit: addHabit),
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Padding(
              padding: EdgeInsets.only(top: 60, left: 20),
              child: Text(
                "Habits",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[850]),
              )),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: BlocConsumer<HabitBloc, HabitState>(
              builder: (BuildContext context, HabitState state) {
                if(state is HabitsLoadSuccess) {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: state.habits.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(state.habits[index].task),
                        ),
                      );
                    },
                  );
                } else {
                  return Text("Hello");
                }
              },
              listener: (BuildContext context, HabitState state) {

              },
            ),
        ),
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

  void addHabit(String habitName) {
    setState(() {
      habitCardList.add(HabitCard(
          habit: Habit(habitName),
          habitStreamController: habitStreamController,
          removeHabit: removeHabit));
      timeUpdateHabit();
    });
  }

  void removeHabit(@required HabitCard habit) {
    setState(() {
      habitCardList.remove(habit);
    });
  }

  void uncheckAllCheckboxes() {
    habitStreamController.add(null);
  }

  void timeUpdateHabit() async {
    while (habitCardList.isNotEmpty) {
      //Wait until midnight
      await Future.delayed(Duration(minutes: minutesLeftOfDay()));
      uncheckAllCheckboxes();
    }
  }

  int minutesLeftOfDay() {
    var minutesPerDay = 1440;
    var pastMinutesToday = TimeOfDay.now().hour * 60 + TimeOfDay.now().minute;
    return minutesPerDay - pastMinutesToday;
  }

  Widget buildPopulatedHabitList(List<Habit> habitList) {
    return Column(
      children: <Widget>[for (var item in habitList) Text(item.task)],
    );
  }
}
