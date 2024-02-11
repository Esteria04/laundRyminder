import 'package:flutter/material.dart';
import 'package:laundryminder/widgets/dorm_buton.dart';
import 'package:laundryminder/widgets/save_button.dart';
import 'package:laundryminder/widgets/title_text.dart';
import 'package:nfc_manager/nfc_manager.dart';

class EntryPage extends StatefulWidget {
  const EntryPage({super.key});

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: screenWidth * 0.3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                  child: TitleText(
                    data: "Select your\ndorm type",
                    fontSize: screenWidth * 0.1,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenWidth * 0.2),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DormButton(width: screenWidth * 0.38, type: 0),
                    DormButton(width: screenWidth * 0.38, type: 1),
                  ],
                ),
                SizedBox(height: screenWidth * 0.08),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DormButton(width: screenWidth * 0.38, type: 2),
                    DormButton(width: screenWidth * 0.38, type: 3),
                  ],
                ),
              ],
            ),
            SizedBox(height: screenWidth * 0.2),
            SaveButton(width: screenWidth),
          ],
        ),
      ),
    );
  }
}
