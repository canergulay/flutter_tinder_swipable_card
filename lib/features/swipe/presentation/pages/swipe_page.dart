import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workbanch/features/swipe/dummy/usermodel.dart';
import 'package:workbanch/features/swipe/dummy/users.dart';
import 'package:workbanch/features/swipe/presentation/bloc/animation_helper_cubit.dart';
import 'package:workbanch/features/swipe/presentation/bloc/swipe_bloc.dart';
import 'package:workbanch/features/swipe/presentation/widgets/user_card.dart';

class SwipeMainPage extends StatefulWidget {
  const SwipeMainPage({Key? key}) : super(key: key);

  @override
  _SwipeMainPageState createState() => _SwipeMainPageState();
}

class _SwipeMainPageState extends State<SwipeMainPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SwipeBloc()),
      ],
      child: Scaffold(
        body: Column(
          children: [
            Expanded(flex: 1, child: Container()),
            users.isEmpty
                ? Text('No more users')
                : Expanded(
                    flex: 15,
                    child: BlocBuilder<SwipeBloc, SwipeState>(
                      builder: (context, state) {
                        return Stack(
                            children: (state as SwipeInitial).users.map((user) {
                          return BlocProvider(
                            create: (context) => AnimationHelperCubit(user.images.length),
                            child: BuildUser(user: user),
                          );
                        }).toList());
                      },
                    )),
            Expanded(flex: 1, child: Container())
          ],
        ),
      ),
    );
  }
}

class BuildUser extends StatefulWidget {
  final User user;
  const BuildUser({Key? key, required this.user}) : super(key: key);

  @override
  _BuildUserState createState() => _BuildUserState();
}

class _BuildUserState extends State<BuildUser> {
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: (pointerEvent) {
        context.read<AnimationHelperCubit>().updatePosition(pointerEvent.localDelta.dx);
      },
      onPointerCancel: (_) {
        context.read<AnimationHelperCubit>().resetPosition();
      },
      onPointerUp: (_) {
        context.read<AnimationHelperCubit>().resetPosition();
      },
      child: Draggable(
        child: UserCardWidget(
          user: widget.user,
        ),
        feedback: BlocProvider.value(
          value: BlocProvider.of<AnimationHelperCubit>(context),
          child: Material(
            type: MaterialType.transparency,
            child: UserCardWidget(
              user: widget.user,
            ),
          ),
        ),
        childWhenDragging: SizedBox(),
        onDragEnd: (details) => onDragEnd(details, widget.user),
      ),
    );
  }

  void onDragEnd(DraggableDetails details, User user) {
    final minimumDrag = 100;
    if (details.offset.dx > minimumDrag) {
      user.isSwipedOff = true;
      BlocProvider.of<SwipeBloc>(context).add(SwipeDelete());
    } else if (details.offset.dx < -minimumDrag) {
      user.isLiked = true;
      BlocProvider.of<SwipeBloc>(context).add(SwipeDelete());
    }
  }
}
