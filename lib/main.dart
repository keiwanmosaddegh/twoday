import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twoday/cubit/habit_cubit.dart';
import 'package:twoday/screens/homepage/habitList.dart';

void main() {
  runApp(BlocProvider(
    create: (context) => HabitCubit()..getAllHabits(),
    child: MaterialApp(
      title: 'twoday',
      debugShowCheckedModeBanner: false,
      home: HabitList(),
    ),
  ));
}
