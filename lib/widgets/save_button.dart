import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({
    super.key,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(width * 0.84 / 30),
          ),
          maximumSize: Size(width * 0.84, width * 0.84),
          backgroundColor: const Color(0xff1B3D71),
          foregroundColor: const Color.fromARGB(255, 98, 138, 197),
        ),
        onPressed: () {},
        child: SizedBox(
          height: width * 0.84 * 0.15,
          width: width * 0.84,
          child: Center(
            child: Text(
              "Save",
              style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.84 * 0.15 * 0.5),
            ),
          ),
        ));
  }
}
