import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:twodayrule/Database.dart';
import 'package:twodayrule/habitCard.dart';
import 'package:twodayrule/homepage/bloc/bloc.dart';
import 'package:twodayrule/modalBottomSheet.dart';

class HabitList extends StatefulWidget {
  @override
  _HabitListState createState() => _HabitListState();
}

class _HabitListState extends State<HabitList> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      DBProvider.db.getLastVisit().then((lastVisit) {
        var currentDateTime = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
        var dateDiff = currentDateTime.difference(lastVisit).inDays;
        if (dateDiff > 0) {
          BlocProvider.of<HabitBloc>(context).add(HabitReseted(dateDiff));
        }
      });
    }
  }

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
              builder: (context) => ModalBottomSheet(),
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
      body: BlocBuilder<HabitBloc, HabitState>(
        builder: (BuildContext context, HabitState state) {
          if (state is HabitsLoadSuccess && state.habits.length > 0) {
            return ListView.builder(
              padding: EdgeInsets.only(bottom: 20),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: state.habits.length,
              itemBuilder: (context, index) {
                return HabitCard(
                  id: state.habits[index].id,
                );
              },
            );
          } else {
            return Padding(
                padding: EdgeInsets.only(top: 10, left: 20),
                child: Text(
                  "Tap the + sign to add your first habit",
                  style: TextStyle(fontSize: 16, color: Colors.grey[850]),
                ));
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
}
