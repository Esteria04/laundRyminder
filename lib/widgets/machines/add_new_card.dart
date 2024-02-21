import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundryminder/utils/prefs.dart';
import 'package:laundryminder/widgets/bottomsheet_button.dart';
import 'package:laundryminder/widgets/rounded_bottomsheet.dart';
import 'package:laundryminder/widgets/submit_button.dart';
import 'package:laundryminder/widgets/time_options_radio.dart';
import 'package:nfc_manager/nfc_manager.dart';

class AddNewCard extends StatefulWidget {
  const AddNewCard({super.key});

  @override
  State<AddNewCard> createState() => _AddNewCardState();
}

class _AddNewCardState extends State<AddNewCard> {
  void onTap() {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        builder: (context) {
          Color textColor = const Color(0xff1C1B64);
          return RoundedBottomSheet(
            widthArg: MediaQuery.of(context).size.width,
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
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                  ),
                ),
                Image.asset(
                  "assets/icons/nfc_tag.png",
                  width: MediaQuery.of(context).size.width * 0.3,
                ),
                Text(
                  "Move your phone closer to the NFC tag.",
                  style: GoogleFonts.inter(
                    color: textColor,
                    fontWeight: FontWeight.normal,
                    fontSize: MediaQuery.of(context).size.width * 0.03,
                  ),
                ),
                BottomSheetButton(
                  widthArg: MediaQuery.of(context).size.width,
                  text: "Cancel",
                ),
              ],
            ),
          );
        });
    readNFC();
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

        Prefs.setMapValue("picked", {
          "dorm": dorm - 48,
          "type": machineType - 48,
          "code": machineCode - 48,
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
          widthArg: MediaQuery.of(context).size.width,
          heightArg: 0.55,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    imgPath,
                    width: MediaQuery.of(context).size.width * 0.28,
                    height: MediaQuery.of(context).size.width * 0.28,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.28,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          machineName,
                          style: GoogleFonts.inter(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width * 0.06,
                          ),
                        ),
                        TimeOptionRadio(
                          widthArg: MediaQuery.of(context).size.width,
                          color: timeRadioColor,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SubmitButton(
                widthArg: MediaQuery.of(context).size.width,
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: screenWidth * 0.84,
          height: screenWidth * 0.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(screenWidth * 0.03),
            color: const Color(0xff1C1B64),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset(
                "assets/icons/add_new.svg",
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
                width: screenWidth * 0.25,
                height: screenWidth * 0.25,
              ),
              Text(
                "Add New",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: screenWidth * 0.12,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
