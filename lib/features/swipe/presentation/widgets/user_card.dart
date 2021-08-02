import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workbanch/core/components/schemas/swipe_color_schema.dart';
import 'package:workbanch/features/swipe/dummy/usermodel.dart';
import 'package:workbanch/features/swipe/presentation/bloc/animation_helper_cubit.dart';

class UserCardWidget extends StatefulWidget {
  final User user;

  const UserCardWidget({
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  _UserCardWidgetState createState() => _UserCardWidgetState();
}

class _UserCardWidgetState extends State<UserCardWidget> with SingleTickerProviderStateMixin {
  late final AnimationController rotateController;

  @override
  void initState() {
    rotateController =
        AnimationController(vsync: this, duration: Duration(seconds: 1), lowerBound: -2.0, upperBound: 2.0, value: 0);
    // TODO: implement initState

    super.initState();
  }

  @override
  void dispose() {
    rotateController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AnimationHelperCubit, AnimationHelperState>(
      listener: (contexta, state) {
        rotateController.value = BlocProvider.of<AnimationHelperCubit>(context, listen: false).rotateValue / 1000;
      },
      builder: (context, state) {
        if (state is AnimationHelperInitial) {
          return AnimatedBuilder(
              animation: rotateController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: rotateController.value,
                  child: buildContainerWimage(MediaQuery.of(context).size, context, rotateController.value * 3),
                );
              });
        } else {
          return Container();
        }
      },
    );
  }

  Container buildContainerWimage(Size size, BuildContext context, double animationValue) {
    return Container(
      height: size.height * 0.7,
      width: size.width * 0.95,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: NetworkImage(
              widget.user.images[BlocProvider.of<AnimationHelperCubit>(context).imageIndex].image ?? 'notfound'),
          fit: BoxFit.cover,
        ),
      ),
      child: buildContainer(context, animationValue),
    );
  }

  Container buildContainer(BuildContext context, double animationValue) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black12, spreadRadius: 0.5),
        ],
        gradient: LinearGradient(
          colors: [Colors.black12, Colors.black87],
          begin: Alignment.center,
          stops: [0.4, 1],
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      print('left one is clicked');
                      BlocProvider.of<AnimationHelperCubit>(context).leftImage();
                    },
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      print('right one is clicked');
                      BlocProvider.of<AnimationHelperCubit>(context).rightImage();
                    },
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            child: Column(
              children: [
                SizedBox(
                  height: 6,
                ),
                Container(
                  child: Row(
                      children: widget.user.images
                          .map((e) => buildExpanded(
                              photoActivateChecker(context.read<AnimationHelperCubit>().imageIndex, e.order ?? 0)))
                          .toList()),
                ),
              ],
            ),
          ),
          buildInfos(),
          buildLikeBadge(context.read<AnimationHelperCubit>().swipingDirection, animationValue)
        ],
      ),
    );
  }

  Expanded buildExpanded(bool isFocused) {
    return Expanded(
      child: Row(
        children: [
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Container(
              color: isFocused ? SwipeColorSchemas.photoActive : SwipeColorSchemas.photoInactive,
              height: 3,
              width: double.infinity,
            ),
          ),
          SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }

  Positioned buildInfos() {
    return Positioned(
      right: 10,
      left: 10,
      bottom: 10,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildUserInfo(user: widget.user),
          Padding(
            padding: EdgeInsets.only(bottom: 16, right: 8),
            child: Icon(Icons.info, color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget buildLikeBadge(
    SwipingDirection swipingDirection,
    double animationValue,
  ) {
    final isSwipingRight = swipingDirection == SwipingDirection.right;

    if (swipingDirection == SwipingDirection.none) {
      return Container();
    } else {
      return Center(
        child: Transform.scale(
          scale: imageScaler(animationValue),
          child: Image.asset(
            imagePath(isSwipingRight),
            scale: 4,
          ),
        ),
      );
    }
  }

  double imageScaler(double animationValue) {
    return (animationValue * 2.5).abs() < 1.6 ? animationValue * 2.5 : 1.6;
  }

  String imagePath(bool isSwipingRight) {
    return isSwipingRight ? 'assets/images/tick.png' : 'assets/images/cross.png';
  }

  Widget buildUserInfo({required User user}) => Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${user.name}, ${user.age}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              user.designation,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 4),
            Text(
              '${user.mutualFriends} Mutual Friends',
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      );
}

bool photoActivateChecker(int myCurrentPlace, int thePlaceOfPhoto) {
  return myCurrentPlace == thePlaceOfPhoto;
}
