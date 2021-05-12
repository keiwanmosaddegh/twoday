import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twodayrule/cubit/habit_cubit.dart';
import 'package:twodayrule/screens/homepage/habitList.dart';

void main() {
  runApp(BlocProvider(
    create: (context) => HabitCubit()..getAllHabits(),
    child: MaterialApp(
      title: 'Two Day Rule',
      debugShowCheckedModeBanner: false,
      home: HabitList(),
    ),
  ));
}
