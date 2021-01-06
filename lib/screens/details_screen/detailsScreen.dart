import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twodayrule/bloc/blocs.dart';

class DetailsScreen extends StatelessWidget {
  final String id;

  DetailsScreen({this.id});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitBloc, HabitState>(
        builder: (BuildContext context, HabitState state) {
      final habit = (state as HabitsLoadSuccess)
          .habits
          .firstWhere((habit) => habit.id == id, orElse: () => null);
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Padding(
                padding: EdgeInsets.only(top: 60, left: 20),
                child: Text(
                  habit.task,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[850]),
                )),
          ),
        ),
        body: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: EdgeInsets.only(left: 18, right: 18, bottom: 20, top: 20),
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              Text(
              "Overview",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[850]),
            ),
                SizedBox(height: 10,),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Q1",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[850]),
                        ),
                        Text(
                          "Q2",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[850]),
                        ),
                        Text(
                          "Q3",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[850]),
                        ),
                        Text(
                          "Q4",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[850]),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
