import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundryminder/utils/prefs.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    required this.widthArg,
    required this.text,
  });

  final double widthArg;
  final String text;
  @override
  Widget build(BuildContext context) {
    final database = FirebaseFirestore.instance;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widthArg * 0.035)),
        backgroundColor: const Color(0xffC5D8FF),
        foregroundColor: Colors.white,
      ),
      onPressed: () {
        Map<String, dynamic> current = Prefs.getMapValue("current");
        String currentDorm =
            ["Men A", "Men B", "Women A", "Women B"][current["dorm"]];
        bool matches = Prefs.getStringValue("dorm") == currentDorm;
        if (matches) {
          database
              .collection("dorms")
              .doc(currentDorm)
              .snapshots()
              .listen((event) {
            print(event.data());
            List<dynamic> response = event.data()!["machines"];
            print(response);
            for (int i = 0; i < response.length; i++) {
              if (response[i]["type"] == ["Washer", "Dryer"][current["type"]] &&
                  response[i]["code"] == current["code"]) {
                response[i]["option"] = Prefs.getIntValue("option");
                DateTime now = DateTime.now();
                String month = "${now.month}".length < 2
                    ? "0${now.month}"
                    : "${now.month}";
                String day =
                    "${now.day}".length < 2 ? "0${now.day}" : "${now.day}";
                String hour =
                    "${now.hour}".length < 2 ? "0${now.hour}" : "${now.hour}";
                String minute = "${now.minute}".length < 2
                    ? "0${now.minute}"
                    : "${now.minute}";
                String second = "${now.second}".length < 2
                    ? "0${now.second}"
                    : "${now.second}";
                response[i]["startedAt"] =
                    "${now.year}$month$day-$hour:$minute:$second";
                response[i]["isRunning"] = true;
                break;
              }
            }
            database
                .collection("dorms")
                .doc(currentDorm)
                .set({"machines": response}, SetOptions(merge: true));
          });
          Navigator.of(context).pop();
        }
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
