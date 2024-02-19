import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundryminder/utils/prefs.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    required this.widthArg,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  });

  final double widthArg;
  final String text;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final database = FirebaseFirestore.instance;

    void onPressed() {
      Map<String, dynamic> picked = Prefs.getMapValue("picked");
      String pickedDorm =
          ["Men A", "Men B", "Women A", "Women B"][picked["dorm"]];
      bool matches = Prefs.getStringValue("dorm") == pickedDorm;
      late List<dynamic> response;
      var document = database.collection("dorms").doc(pickedDorm);
      late Map<String, dynamic> machine;
      if (matches) {
        document.get().then((doc) {
          response = doc.data()!["machines"];
          for (int i = 0; i < response.length; i++) {
            if (response[i]["type"] == ["Washer", "Dryer"][picked["type"]] &&
                response[i]["code"] == picked["code"]) {
              response[i]["option"] = Prefs.getIntValue("option");

              Timestamp now = Timestamp.fromDate(DateTime.now());
              response[i]["startedAt"] = now;
              response[i]["isRunning"] = true;
              response[i]["isDisabled"] = false;
              machine = response[i];
              break;
            }
          }
        }).then((value) {
          document.set({"machines": response}, SetOptions(merge: true));
          Prefs.setMapValue("current", {
            "type": machine["type"],
            "code": machine["code"],
          });
        }).then((value) {
          Navigator.of(context).pop();
        });
      }
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widthArg * 0.035)),
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
      ),
      onPressed: onPressed,
      child: SizedBox(
        width: widthArg * 0.6,
        height: widthArg * 0.6 / 6,
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.inter(
              color: textColor,
              fontWeight: FontWeight.normal,
              fontSize: widthArg * 0.035,
            ),
          ),
        ),
      ),
    );
  }
}
