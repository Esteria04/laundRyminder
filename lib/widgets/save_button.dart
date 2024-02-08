import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundryminder/pages/main_page.dart';

class SaveButton extends StatefulWidget {
  const SaveButton({
    super.key,
    required this.width,
  });

  final double width;

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.width * 0.84 / 30),
          ),
          maximumSize: Size(widget.width * 0.84, widget.width * 0.84),
          backgroundColor: const Color(0xff1B3D71),
          foregroundColor: const Color.fromARGB(255, 98, 138, 197),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MainPage(),
            ),
          );
        },
        child: SizedBox(
          height: widget.width * 0.84 * 0.15,
          width: widget.width * 0.84,
          child: Center(
            child: Text(
              "Save",
              style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: widget.width * 0.84 * 0.15 * 0.5),
            ),
          ),
        ));
  }
}
