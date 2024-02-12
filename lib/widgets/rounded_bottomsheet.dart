import 'package:flutter/material.dart';

class RoundedBottomSheet extends StatefulWidget {
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
  State<RoundedBottomSheet> createState() => _RoundedBottomSheetState();
}

class _RoundedBottomSheetState extends State<RoundedBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: SizedBox(
        width: widget.widthArg,
        height: widget.widthArg * widget.heightArg,
        child: widget.child,
      ),
    );
  }
}
