import 'package:flutter/material.dart';

class RoundedBottomSheet extends StatelessWidget {
  const RoundedBottomSheet({
    super.key,
    required this.widthArg,
    required this.heightArg,
    required this.child,
  });

  final double widthArg;
  final double heightArg;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widthArg * 0.16),
      child: SizedBox(
        width: widthArg,
        height: widthArg * heightArg,
        child: child,
      ),
    );
  }
}
