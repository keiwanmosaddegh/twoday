import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twoday/common/constants.dart';
import 'package:twoday/cubit/habit_cubit.dart';
import 'package:twoday/models/habit.dart';

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
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                      style: TextStyle(color: kBlue),
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
      textCapitalization: TextCapitalization.sentences,
      controller: newHabitController,
      cursorColor: kOnBackground,
      decoration: InputDecoration(
          hintText: "New habit",
          border: InputBorder.none,
          hintStyle: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 18, color: kHintText)),
    );
  }
}
