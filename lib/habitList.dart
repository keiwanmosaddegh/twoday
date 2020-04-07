import 'package:flutter/material.dart';
import 'package:twodayrule/habitCardTemplate.dart';
import 'package:twodayrule/habit.dart';
import 'package:twodayrule/modalBottomSheet.dart';

class HabitList extends StatefulWidget {
  @override
  _HabitListState createState() => _HabitListState();
}

class _HabitListState extends State<HabitList> {
  List<Habit> habitList = [Habit("Brush teeth"), Habit("Work out")];

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
                  color: Colors.white
                ),
              )),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: 30),
          child: Column(
              children: habitList
                  .map((habit) => HabitCardTemplate(habit: habit))
                  .toList()),
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
    });
  }
}
