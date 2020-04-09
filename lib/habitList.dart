import 'dart:async';
import 'package:flutter/material.dart';
import 'package:twodayrule/habitCard.dart';
import 'package:twodayrule/habit.dart';
import 'package:twodayrule/modalBottomSheet.dart';

class HabitList extends StatefulWidget {

  @override
  _HabitListState createState() => _HabitListState();
}

class _HabitListState extends State<HabitList> {
  List<HabitCard> habitCardList = [];
  StreamController<void> habitStreamController = StreamController<void>.broadcast();

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
                builder: (context) => ModalBottomSheet(
                      addHabit: addHabit,
                    ));
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
          child: habitCardList.isNotEmpty
              ? Column(children: habitCardList)
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
      habitCardList.add(HabitCard(habit: Habit(habitName), habitStreamController: habitStreamController));
      timeUpdateHabit();
    });
  }
  
  void uncheckAllCheckboxes() {
    habitStreamController.add(null);
  }

  void timeUpdateHabit() async {
    while (habitCardList.isNotEmpty) {
      //Wait until midnight
      await Future.delayed(Duration(minutes: minutesLeftOfDay()));
      //Reset our checkboxes for the day
      uncheckAllCheckboxes();

      //skapa metod som går igenom alla habits i listan, ser hur länge sedan deras
      //senaste tick var*, och reagera olika beroende på just det.




      //*Innan vi kan fortsätta här måste vi ha sparat undan varje gång en habit tickas.
      //Detta vill vi nog göra i Habits-klassen, genom att skapa en stack, där senaste ticken sparas
      //överst, och att stacken har ett utrymme på 3 platser.
    }
  }

  int minutesLeftOfDay() {
    var minutesPerDay = 1440;
    var pastMinutesToday = TimeOfDay.now().hour * 60 + TimeOfDay.now().minute;
    return minutesPerDay - pastMinutesToday;
  }
}
