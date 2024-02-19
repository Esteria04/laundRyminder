import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundryminder/utils/prefs.dart';

class TimeOptionRadio extends StatefulWidget {
  const TimeOptionRadio({
    super.key,
    required this.widthArg,
    required this.color,
  });

  final double widthArg;
  final Color color;
  @override
  State<TimeOptionRadio> createState() => _TimeOptionRadioState();
}

class _TimeOptionRadioState extends State<TimeOptionRadio> {
  int picked = -1;
  @override
  Widget build(BuildContext context) {
    Color defaultColor = const Color(0xffA0A2BA);
    Color pickedColor = widget.color;
    double size = widget.widthArg * 0.18;
    return SizedBox(
      width: size * 3 + widget.widthArg * 0.08,
      height: size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                picked = 0;
              });
              Prefs.setIntValue("option", 0);
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shadowColor: Colors.transparent,
              backgroundColor: picked == 0 ? pickedColor : defaultColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(size * 0.4),
              ),
              padding: const EdgeInsets.all(0),
              maximumSize: Size(size, size),
            ),
            child: SizedBox(
              width: size,
              height: size,
              child: Center(
                child: Text(
                  "45m",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: size * 0.25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                picked = 1;
              });
              Prefs.setIntValue("option", 1);
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shadowColor: Colors.transparent,
              backgroundColor: picked == 1 ? pickedColor : defaultColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(size * 0.4),
              ),
              padding: const EdgeInsets.all(0),
              maximumSize: Size(size, size),
            ),
            child: SizedBox(
              width: size,
              height: size,
              child: Center(
                child: Text(
                  "50m",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: size * 0.25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                picked = 2;
              });
              Prefs.setIntValue("option", 2);
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shadowColor: Colors.transparent,
              backgroundColor: picked == 2 ? pickedColor : defaultColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(size * 0.4),
              ),
              padding: const EdgeInsets.all(0),
              maximumSize: Size(size, size),
            ),
            child: SizedBox(
              width: size,
              height: size,
              child: Center(
                child: Text(
                  "1h20m",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: size * 0.25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
