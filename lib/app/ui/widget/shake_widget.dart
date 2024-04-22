import 'dart:math';

import 'package:flutter/material.dart';


class SineCurve extends Curve {
  const SineCurve({this.count = 3});

  final double count;

  @override
  double transformInternal(double t) {
    return sin(count * 2 * pi * t);
  }
}

abstract class AnimationControllerState<T extends StatefulWidget>
    extends State<T> with SingleTickerProviderStateMixin {
  AnimationControllerState(this.animationDuration);

  final Duration animationDuration;
  late final animationController =
  AnimationController(vsync: this, duration: animationDuration);

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class ShakeWidget extends StatefulWidget {
  const ShakeWidget({
    Key? key,
    required this.child,
    required this.shakeOffset,
    this.shakeCount = 2,
    this.shakeDuration = const Duration(milliseconds: 1000),
  }) : super(key: key);

  final Widget child;

  final double shakeOffset;
  final int shakeCount;
  final Duration shakeDuration;

  @override
  ShakeWidgetState createState() => ShakeWidgetState(shakeDuration);
}

class ShakeWidgetState extends AnimationControllerState<ShakeWidget> {
  ShakeWidgetState(Duration duration) : super(duration);

  late final Animation<double> _sineAnimation = Tween(
    begin: 0.0,
    end: 1.0,
  ).animate(
    CurvedAnimation(
      parent: animationController,
      curve: SineCurve(count: widget.shakeCount.toDouble()),
    ),
  );

  Alignment _alignment = Alignment.center;

  @override
  void initState() {
    super.initState();
    _loopAnimation();
  }

  var temp = 0.0;

  void _loopAnimation() async {
    temp = widget.shakeOffset;

    animationController.reset();
    animationController.forward().then((_) {
      setState(() {
        _alignment =
            Alignment.center; // Đặt child về giữa layout khi animation kết thúc
        temp = 0;
      });

      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          setState(() {
            _alignment = Alignment.center; // Đặt child ở vị trí ban đầu
            temp = 0;
          });
          _loopAnimation();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: _alignment, // Sử dụng Align để đặt vị trí của child
      child: AnimatedBuilder(
        animation: _sineAnimation,
        child: widget.child,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_sineAnimation.value * temp, 0),
            child: child,
          );
        },
      ),
    );
  }
}
