import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class MachineCard extends StatelessWidget {
  const MachineCard({
    super.key,
    required this.widthArg,
    required this.machine,
  });

  final double widthArg;
  final Map<String, dynamic> machine;

  @override
  Widget build(BuildContext context) {
    Row content;
    if (machine.isEmpty) {
      content = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SvgPicture.asset(
            "assets/icons/add_new.svg",
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
            width: widthArg * 0.25,
            height: widthArg * 0.25,
          ),
          Text(
            "Add New",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: widthArg * 0.12,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      );
    } else {
      content = const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [],
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        child: Container(
          width: widthArg * 0.84,
          height: widthArg * 0.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widthArg * 0.03),
            color: const Color(0xff1C1B64),
          ),
          child: content,
        ),
      ),
    );
  }
}
