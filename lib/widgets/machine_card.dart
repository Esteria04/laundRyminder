import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundryminder/utils/prefs.dart';
import 'package:laundryminder/widgets/bottomsheet_button.dart';
import 'package:laundryminder/widgets/rounded_bottomsheet.dart';
import 'package:nfc_manager/nfc_manager.dart';

class MachineCard extends StatefulWidget {
  const MachineCard({
    super.key,
    required this.widthArg,
    required this.machine,
  });

  final double widthArg;
  final Map<String, dynamic> machine;

  @override
  State<MachineCard> createState() => _MachineCardState();
}

class _MachineCardState extends State<MachineCard> {
  int remainingTime = 5000;
  late Timer timer;
  late bool isAddNew;

  @override
  void initState() {
    super.initState();
    isAddNew = widget.machine.isEmpty ? true : false;
    if (widget.machine["remainingTime"] != null) {
      remainingTime = widget.machine["remainingTime"];
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            if (remainingTime > 0) {
              remainingTime--;
            } else {
              return;
            }
          });
        }
      });
    }
  }

  void onTap() {
    if (isAddNew) {
      showModalBottomSheet(
          context: context,
          isDismissible: false,
          builder: (context) {
            Color textColor = const Color(0xff1C1B64);
            return RoundedBottomSheet(
              widthArg: widget.widthArg,
              heightArg: 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Ready to Scan",
                    style: GoogleFonts.inter(
                      color: textColor,
                      fontWeight: FontWeight.normal,
                      fontSize: widget.widthArg * 0.05,
                    ),
                  ),
                  Image.asset(
                    "assets/icons/nfc_tag.png",
                    width: widget.widthArg * 0.3,
                  ),
                  Text(
                    "Move your phone closer to the NFC tag.",
                    style: GoogleFonts.inter(
                      color: textColor,
                      fontWeight: FontWeight.normal,
                      fontSize: widget.widthArg * 0.03,
                    ),
                  ),
                  BottomSheetButton(
                    widthArg: widget.widthArg,
                    text: "Cancel",
                  ),
                ],
              ),
            );
          });
      readNFC();
    }
  }

  void readNFC() {
    NfcManager.instance.startSession(
      onError: (error) {
        throw Exception(error);
      },
      onDiscovered: (NfcTag tag) async {
        int dorm = List<int>.from(
                tag.data["ndef"]["cachedMessage"]["records"][0]["type"])[0] -
            48;
        int machineType = List<int>.from(
                tag.data["ndef"]["cachedMessage"]["records"][0]["type"])[2] -
            48;
        int machineCode = List<int>.from(
                tag.data["ndef"]["cachedMessage"]["records"][0]["payload"])[0] -
            48;

        Prefs.setMapValue("current", {
          "dorm": dorm,
          "machineType": machineType,
          "machineCode": machineCode
        });
      },
    );
  }

  // type, code, isCurrent, isDisabled, isRunning, remainingTime
  @override
  Widget build(BuildContext context) {
    String imgPath, statusText, nameText;
    Color backgroundColor, statusColor, nameColor;
    Row content;
    if (widget.machine.isEmpty) {
      content = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SvgPicture.asset(
            "assets/icons/add_new.svg",
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
            width: widget.widthArg * 0.25,
            height: widget.widthArg * 0.25,
          ),
          Text(
            "Add New",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: widget.widthArg * 0.12,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      );
      backgroundColor = const Color(0xff1C1B64);
    } else {
      nameText = widget.machine["type"] + " No." + "${widget.machine["code"]}";

      if (widget.machine["type"] == "Washer") {
        // washer
        if (widget.machine["isCurrent"]) {
          backgroundColor = const Color(0xff1C1B64);
          nameColor = statusColor = Colors.white;
        } else {
          backgroundColor = const Color(0xff8DA7EC);
          nameColor = const Color(0xff064667);
          statusColor = const Color(0xff4066B0);
        }
        statusText = '${remainingTime ~/ 60} m ${remainingTime % 60} s';
        if (widget.machine["isRunning"]) {
          imgPath = "assets/washer_running.gif";
        } else {
          imgPath = "assets/washer_vacant.png";
          statusText = "VACANT";
        }
        if (remainingTime == 0) {
          statusText = "VACANT";
          imgPath = "assets/washer_vacant.png";
        }
      } else {
        // dryer
        if (widget.machine["isCurrent"]) {
          backgroundColor = const Color(0xff7C0016);
          nameColor = statusColor = Colors.white;
        } else {
          backgroundColor = const Color(0xffEE9595);
          nameColor = const Color(0xffB83C40);
          statusColor = const Color(0xff9F292E);
        }
        statusText = '${remainingTime ~/ 60} m ${remainingTime % 60} s';
        if (widget.machine["isRunning"]) {
          imgPath = "assets/dryer_running.gif";
        } else {
          imgPath = "assets/dryer_vacant.png";
          statusText = "VACANT";
        }
        if (remainingTime == 0) {
          statusText = "VACANT";
          imgPath = "assets/dryer_vacant.png";
        }
      }

      if (widget.machine["isDisabled"]) {
        // disabled
        imgPath = "assets/disabled.png";
        backgroundColor = const Color(0xffABABAB);
        nameColor = const Color(0xff525252);
        statusColor = const Color(0xffE0E0E0);
        statusText = "DISABLED";
      }

      Image icon = Image.asset(
        imgPath,
        width: widget.widthArg * 0.25,
        height: widget.widthArg * 0.25,
      );

      content = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: widget.widthArg * 0.025),
          icon,
          SizedBox(width: widget.widthArg * 0.025),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: widget.widthArg * 0.05),
              Text(
                nameText,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: nameColor,
                  fontSize: widget.widthArg * 0.06,
                  height: 0.3,
                ),
              ),
              Text(
                statusText,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                  fontSize: widget.widthArg * 0.1,
                ),
              ),
            ],
          )
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: widget.widthArg * 0.84,
          height: widget.widthArg * 0.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.widthArg * 0.03),
            color: backgroundColor,
          ),
          child: content,
        ),
      ),
    );
  }
}
