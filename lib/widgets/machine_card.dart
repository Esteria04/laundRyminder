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
  // type, code, isCurrent, isDisabled, isRunning, remainingTime
  @override
  Widget build(BuildContext context) {
    String imgPath, statusText, nameText;
    Color backgroundColor, statusColor, nameColor;
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
      backgroundColor = const Color(0xff1C1B64);
    } else {
      nameText = machine["type"] + " No." + "${machine["code"]}";

      if (machine["type"] == "Washer") {
        // washer
        if (machine["isCurrent"]) {
          backgroundColor = const Color(0xff1C1B64);
          nameColor = statusColor = Colors.white;
        } else {
          backgroundColor = const Color(0xff8DA7EC);
          nameColor = const Color(0xff064667);
          statusColor = const Color(0xff4066B0);
        }
        statusText = machine["remainingTime"];
        if (machine["isRunning"]) {
          imgPath = "assets/washer_running.gif";
        } else {
          imgPath = "assets/washer_vacant.png";
          statusText = "VACANT";
        }
      } else {
        // dryer
        if (machine["isCurrent"]) {
          backgroundColor = const Color(0xff7C0016);
          nameColor = statusColor = Colors.white;
        } else {
          backgroundColor = const Color(0xffEE9595);
          nameColor = const Color(0xffB83C40);
          statusColor = const Color(0xff9F292E);
        }
        statusText = machine["remainingTime"];
        if (machine["isRunning"]) {
          imgPath = "assets/dryer_running.gif";
        } else {
          imgPath = "assets/dryer_vacant.png";
          statusText = "VACANT";
        }
      }

      if (machine["isDisabled"]) {
        // disabled
        imgPath = "assets/disabled.png";
        backgroundColor = const Color(0xffABABAB);
        nameColor = const Color(0xff525252);
        statusColor = const Color(0xffE0E0E0);
        statusText = "DISABLED";
      }

      Image icon = Image.asset(
        imgPath,
        width: widthArg * 0.25,
        height: widthArg * 0.25,
      );

      content = Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          icon,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: widthArg * 0.05),
              Text(
                nameText,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: nameColor,
                  fontSize: widthArg * 0.06,
                  height: 0.3,
                ),
              ),
              Text(
                statusText,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                  fontSize: widthArg * 0.1,
                ),
              ),
            ],
          )
        ],
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
            color: backgroundColor,
          ),
          child: content,
        ),
      ),
    );
  }
}
