import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:workbanch/features/swipe/dummy/usermodel.dart';
import 'package:workbanch/features/swipe/dummy/users.dart';
part 'swipe_event.dart';
part 'swipe_state.dart';

class SwipeBloc extends Bloc<SwipeEvent, SwipeState> {
  SwipeBloc() : super(SwipeInitial(users));
  @override
  Stream<SwipeState> mapEventToState(
    SwipeEvent event,
  ) async* {
    if (event is SwipeDelete) {
      final users = (state as SwipeInitial).users;
      users.removeAt(users.indexOf(users.last));
      yield SwipeInitial(users);
    }
    // TODO: implement mapEventToState
  }
}
