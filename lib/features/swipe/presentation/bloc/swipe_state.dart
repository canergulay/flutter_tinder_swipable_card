part of 'swipe_bloc.dart';

@immutable
abstract class SwipeState {}

class SwipeInitial extends SwipeState {
  final List<User> users;
  SwipeInitial(this.users);
}
