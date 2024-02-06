import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleText extends StatelessWidget {
  const TitleText({
    super.key,
    required this.data,
    required this.fontSize,
  });

  final String data;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: GoogleFonts.inter(
        color: const Color(0xff1B3D71),
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
        letterSpacing: -2,
        height: 36 / fontSize,
      ),
    );
  }
}
