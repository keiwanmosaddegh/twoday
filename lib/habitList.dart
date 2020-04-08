import 'package:flutter/material.dart';
import 'package:twodayrule/habitCardTemplate.dart';
import 'package:twodayrule/habit.dart';
import 'package:twodayrule/modalBottomSheet.dart';

class HabitList extends StatefulWidget {
  @override
  _HabitListState createState() => _HabitListState();
}

class _HabitListState extends State<HabitList> {
  List<Habit> habitList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[800],
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
                builder: (context) => ModalBottomSheet(
                      addHabit: addHabit,
                    ));
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.blueGrey[800],
          elevation: 0,
          flexibleSpace: Padding(
              padding: EdgeInsets.only(top: 60, left: 20),
              child: Text(
                "Habits",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              )),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: 30),
          child: habitList.isNotEmpty
              ? Column(
                  children: habitList
                      .map((habit) => HabitCardTemplate(habit: habit))
                      .toList())
              : Padding(
                  padding: EdgeInsets.only(left: 20, top: 10),
                  child: Text(
                    "Habit list is empty",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white30,
                        fontStyle: FontStyle.italic),
                  ),
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

  void addHabit(habitName) {
    setState(() {
      habitList.add(Habit(habitName));
      timeUpdateHabit();
    });
  }



  int minutesLeftOfDay() {
    var minutesPerDay = 1440;
    var pastMinutesToday = TimeOfDay.now().hour*60 + TimeOfDay.now().minute;
    return minutesPerDay - pastMinutesToday;
  }

  void timeUpdateHabit() async {

    while(habitList.isNotEmpty) {
      await Future.delayed(Duration(minutes: minutesLeftOfDay()));

    }
  }
}
