import 'package:equatable/equatable.dart';

class Habit extends Equatable {
  final String task;
  final bool complete;

  Habit(this.task, { this.complete = false });

  Habit copyWith({ String name, bool complete }) {
    return Habit(
      name ?? this.task,
      complete: complete ?? this.complete,
    );
  }

  @override toString() {
    return 'Habit { name: $task, complete: $complete }';
  }

  @override
  List<Object> get props => [task, complete];


}