import 'package:flutter/material.dart';

class Dot extends StatelessWidget {
  final EdgeInsets? margin;
  final double size;
  final Color? color;

  const Dot({Key? key, this.margin, required this.size, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: margin ?? const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color ?? const Color(0xFF878787),
      ),
    );
  }
}