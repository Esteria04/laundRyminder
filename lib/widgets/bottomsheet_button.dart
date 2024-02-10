import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomSheetButton extends StatelessWidget {
  const BottomSheetButton({
    super.key,
    required this.widthArg,
    required this.text,
  });

  final double widthArg;
  final String text;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widthArg * 0.035)),
        backgroundColor: const Color(0xffC5D8FF),
        foregroundColor: Colors.white,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: SizedBox(
        width: widthArg * 0.6,
        height: widthArg * 0.6 / 6,
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.inter(
              color: const Color(0xff1C1B64),
              fontWeight: FontWeight.normal,
              fontSize: widthArg * 0.035,
            ),
          ),
        ),
      ),
    );
  }
}
