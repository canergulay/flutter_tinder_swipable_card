import 'package:flutter/animation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum SwipingDirection { left, right, none }

abstract class AnimationHelperState {}

class AnimationHelperInitial extends AnimationHelperState {}

class AnimationHelperCubit extends Cubit<AnimationHelperState> {
  late final int numberOfImages;
  AnimationHelperCubit(this.numberOfImages) : super(AnimationHelperInitial());

  double _dx = 0.0;
  double rotateValue = 0;
  SwipingDirection _swipingDirection = SwipingDirection.none;

  SwipingDirection get swipingDirection => _swipingDirection;

  feedbackPositionProvider() {
    _swipingDirection = SwipingDirection.none;
  }

  int imageIndex = 0;

  void resetPosition() {
    _dx = 0.0;
    _swipingDirection = SwipingDirection.none;
    emit(AnimationHelperInitial());
  }

  void updatePosition(double changeInX) {
    _dx = _dx + changeInX;
    rotateValue = _dx;
    if (_dx > 0) {
      _swipingDirection = SwipingDirection.right;
    } else if (_dx < 0) {
      _swipingDirection = SwipingDirection.left;
    } else {
      _swipingDirection = SwipingDirection.none;
    }
    emit(AnimationHelperInitial());
  }

  void leftImage() {
    if (imageIndex != 0) {
      imageIndex = imageIndex - 1;
      emit(AnimationHelperInitial());
    }
  }

  void rightImage() {
    if (imageIndex != numberOfImages - 1) {
      imageIndex = imageIndex + 1;
      emit(AnimationHelperInitial());
    }
  }

  //Animation Section

}
