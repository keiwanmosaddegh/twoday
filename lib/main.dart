import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twodayrule/homepage/bloc/bloc.dart';
import 'habitList.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => HabitBloc()..add(HabitsLoaded()),
      child: MaterialApp(
        title: 'Two Day Rule',
        home: HabitList(),
      ),
    )
  );
}

