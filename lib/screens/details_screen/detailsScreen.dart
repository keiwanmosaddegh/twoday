import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twodayrule/bloc/blocs.dart';

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Padding(
                padding: EdgeInsets.only(top: 60, left: 20),
                child: Text(
                  "Hello",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[850]),
                )),
          ),
        ),
        body: BlocBuilder<DetailsBloc, DetailsState>(
            builder: (BuildContext context, DetailsState state) {
              if (state is DetailsLoadSuccess) {
                final habit = state.habit;
                return Text("habit: ${habit.id}");
              }
              return Text("Hej");
        }));
  }
}
