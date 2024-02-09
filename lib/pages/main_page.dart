import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:laundryminder/widgets/machine_card.dart';
import 'package:laundryminder/widgets/title_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _database = FirebaseFirestore.instance;
  String? dorm;
  String? current;

  @override
  void initState() {
    super.initState();
    initializeDorm();
  }

  void initializeDorm() async {
    final prefs = await SharedPreferences.getInstance();
    dorm = prefs.getString("dorm");
    current = prefs.getString("current");
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: screenWidth * 0.25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                child: TitleText(
                  data: "Recently used",
                  fontSize: screenWidth * 0.07,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                child: TitleText(
                  data: "Currently using",
                  fontSize: screenWidth * 0.07,
                ),
              ),
            ],
          ),
          StreamBuilder(
              stream: _database.collection("dorms").doc(dorm).snapshots(),
              builder: (context, snapshot) {
                if (current == null) {
                  return MachineCard(widthArg: screenWidth, machine: const {
                    "type": "Dryer",
                    "code": 1,
                    "isCurrent": true,
                    "isDisabled": false,
                    "isRunning": true,
                    "remainingTime": "42 m 23 s",
                  });
                }
                List<String> data = current!.split(":");
                String type = data[0];
                int code = int.parse(data[1]);
                return GestureDetector(
                  child: Container(
                    width: screenWidth * 0.84,
                    height: screenWidth * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      color: const Color(0xff1C1B64),
                    ),
                    child: const Text("hello"),
                  ),
                );
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                child: TitleText(
                  data: "Machines",
                  fontSize: screenWidth * 0.07,
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
