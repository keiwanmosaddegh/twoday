import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twodayrule/common/constants.dart';
import 'package:twodayrule/cubit/habit_cubit.dart';
import 'package:twodayrule/models/habit.dart';

class ModalBottomSheet extends StatefulWidget {
  @override
  _ModalBottomSheetState createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  final newHabitController = TextEditingController();

  @override
  void dispose() {
    newHabitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.fromLTRB(26, 16, 12, 8),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            HabitTextField(newHabitController: newHabitController),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                    child: Text(
                      "Save",
                      style: TextStyle(color: kSecondary),
                    ),
                    onPressed: () async {
                      await BlocProvider.of<HabitCubit>(context)
                          .createHabit(Habit(newHabitController.text));
                      Navigator.pop(context);
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class HabitTextField extends StatelessWidget {
  final TextEditingController newHabitController;

  HabitTextField({this.newHabitController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: kOnSurface,
      style: TextStyle(color: kOnSurface),
      textCapitalization: TextCapitalization.sentences,
      controller: newHabitController,
      decoration: InputDecoration(
          hintText: "New habit",
          border: InputBorder.none,
          hintStyle: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 18, color: kHintText)),
    );
  }
}
