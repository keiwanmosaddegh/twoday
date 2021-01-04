import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:twodayrule/models/habit.dart';
import 'package:twodayrule/services/Database.dart';

part 'details_event.dart';

part 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  @override
  DetailsState get initialState => DetailsLoadInProgress();

  @override
  Stream<DetailsState> mapEventToState(DetailsEvent event) async* {
    if (event is DetailsLoaded) {
      yield* _mapDetailsLoadedToState(event);
    } else if (event is DetailsUpdated) {
      yield* _mapDetailsUpdatedToState();
    }
  }

  Stream<DetailsState> _mapDetailsLoadedToState(DetailsLoaded event) async* {
    final habit = await DBProvider.db.getHabit(event.habit);
    yield DetailsLoadSuccess(habit);
  }

  Stream<DetailsState> _mapDetailsUpdatedToState() async* {
  }

}
