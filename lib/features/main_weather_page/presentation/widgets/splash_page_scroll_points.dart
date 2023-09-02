// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ScrollPoints extends StatelessWidget {
  final double size;
  final Color color;
  const ScrollPoints({
    Key? key,
    required this.size,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          width: size,
          height: size,
          duration: const Duration(
            milliseconds: 200,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: color,
          ),
        ),
      ],
    );
  }
}
