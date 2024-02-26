import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundryminder/utils/prefs.dart';
import 'package:laundryminder/widgets/bottomsheet_button.dart';
import 'package:laundryminder/widgets/rounded_bottomsheet.dart';
import 'package:laundryminder/widgets/submit_button.dart';
import 'package:laundryminder/widgets/time_options_radio.dart';
import 'package:nfc_manager/nfc_manager.dart';

class MachineCard extends StatefulWidget {
  const MachineCard({
    super.key,
    required this.widthArg,
    required this.machine,
    required this.isCurrent,
    required this.isAddNew,
  });

  final double widthArg;
  final Map<String, dynamic> machine;
  final bool isCurrent;
  final bool isAddNew;
  @override
  State<MachineCard> createState() => _MachineCardState();
}

class _MachineCardState extends State<MachineCard> {
  late int remainingTime;
  Timer? timer;

  void onTap() {
    if (widget.isAddNew) {
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
            tag.data["ndef"]["cachedMessage"]["records"][0]["type"])[0];
        int machineType = List<int>.from(
            tag.data["ndef"]["cachedMessage"]["records"][0]["type"])[2];
        int machineCode = List<int>.from(
            tag.data["ndef"]["cachedMessage"]["records"][0]["payload"])[0];
        // - 48 for converting ASCII code to decimal number
        Prefs.setMapValue("picked", {
          "dorm": dorm - 48,
          "type": machineType - 48,
          "code": machineCode - 48
        });
        NfcManager.instance.stopSession();
        Navigator.of(context).pop();
        showMachineSelectSheet();
      },
    );
  }

  void showMachineSelectSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        Map<String, dynamic> machine = Prefs.getMapValue("picked");
        String imgPath =
            machine["type"] == 0 ? "assets/washer.png" : "assets/dryer.png";
        String machineName = machine["type"] == 0
            ? "Washer No.${machine["code"]}"
            : "Dryer No.${machine["code"]}";
        Color submitBtnColor = machine["type"] == 0
            ? const Color(0xffC5D8FF)
            : const Color(0xffFFC5C5);
        Color textColor = machine["type"] == 0
            ? const Color(0xff1C1B64)
            : const Color(0xff940000);
        Color timeRadioColor = machine["type"] == 0
            ? const Color(0xff2E3784)
            : const Color(0xff842E2E);

        return RoundedBottomSheet(
          widthArg: widget.widthArg,
          heightArg: 0.55,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    imgPath,
                    width: widget.widthArg * 0.28,
                    height: widget.widthArg * 0.28,
                  ),
                  SizedBox(
                    height: widget.widthArg * 0.28,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          machineName,
                          style: GoogleFonts.inter(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: widget.widthArg * 0.06,
                          ),
                        ),
                        TimeOptionRadio(
                            widthArg: widget.widthArg, color: timeRadioColor),
                      ],
                    ),
                  )
                ],
              ),
              SubmitButton(
                widthArg: widget.widthArg,
                text: "Start",
                backgroundColor: submitBtnColor,
                textColor: textColor,
              ),
            ],
          ),
        );
      },
    );
  }

  void startTimer() {
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

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void didUpdateWidget(covariant MachineCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget != oldWidget) {
      timer?.cancel();
      startTimer();
    }
  }

  Map<String, dynamic> machineParser(Map<String, dynamic> machine) {
    if (machine.isEmpty) return {};
    String imgPath, statusText, nameText;
    Color backgroundColor, statusColor, nameColor;
    nameText = machine["type"] + " No." + "${machine["code"]}";
    if (machine["type"] == "Washer") {
      // washer
      if (widget.isCurrent) {
        backgroundColor = const Color(0xff1C1B64);
        nameColor = statusColor = Colors.white;
      } else {
        backgroundColor = const Color(0xff8DA7EC);
        nameColor = const Color(0xff064667);
        statusColor = const Color(0xff4066B0);
      }
      statusText = '${remainingTime ~/ 60} m ${remainingTime % 60} s';
      if (machine["isRunning"]) {
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
      if (widget.isCurrent) {
        backgroundColor = const Color(0xff7C0016);
        nameColor = statusColor = Colors.white;
      } else {
        backgroundColor = const Color(0xffEE9595);
        nameColor = const Color(0xffB83C40);
        statusColor = const Color(0xff9F292E);
      }
      statusText = '${remainingTime ~/ 60} m ${remainingTime % 60} s';
      if (machine["isRunning"]) {
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

    if (machine["isDisabled"]) {
      // disabled
      imgPath = "assets/disabled.png";
      backgroundColor = const Color(0xffABABAB);
      nameColor = const Color(0xff525252);
      statusColor = const Color(0xffE0E0E0);
      statusText = "DISABLED";
    }

    return {
      "imgPath": imgPath,
      "statusText": statusText,
      "statusColor": statusColor,
      "nameText": nameText,
      "nameColor": nameColor,
      "backgroundColor": backgroundColor,
    };
  }

  // type, code, isCurrent, isDisabled, isRunning, remainingTime
  @override
  Widget build(BuildContext context) {
    final database = FirebaseFirestore.instance;
    Row content;
    Map<String, dynamic> data = machineParser(widget.machine);
    if (widget.isAddNew) {
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
    } else {
      Image icon = Image.asset(
        data["imgPath"],
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
                data["nameText"],
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: data["nameColor"],
                  fontSize: widget.widthArg * 0.06,
                  height: 0.3,
                ),
              ),
              Text(
                data["statusText"],
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: data["statusColor"],
                  fontSize: widget.widthArg * 0.1,
                ),
              ),
            ],
          )
        ],
      );
    }

    if (data["statusText"] == "VACANT") {
      Map<String, dynamic> picked = Prefs.getMapValue("picked");
      String pickedDorm =
          ["Men A", "Men B", "Women A", "Women B"][picked["dorm"]];
      bool matches = Prefs.getStringValue("dorm") == pickedDorm;
      late List<dynamic> response;
      var document = database.collection("dorms").doc(pickedDorm);
      if (matches) {
        document.get().then((doc) {
          response = doc.data()!["machines"];
          for (int i = 0; i < response.length; i++) {
            if (response[i]["type"] == ["Washer", "Dryer"][picked["type"]] &&
                response[i]["code"] == picked["code"]) {
              response[i]["option"] = Prefs.getIntValue("option");
              Timestamp now = Timestamp.fromDate(DateTime.now());
              response[i]["startedAt"] = now;
              response[i]["isRunning"] = false;
              response[i]["isDisabled"] = false;
              break;
            }
          }
        }).then((value) {
          document.set({"machines": response}, SetOptions(merge: true));
        });
      }
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
            color: data["backgroundColor"] ??
                const Color(
                    0xff1C1B64), // data["key"] being null means addNew card should be placed.
          ),
          child: content,
        ),
      ),
    );
  }
}
