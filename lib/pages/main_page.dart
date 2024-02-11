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
      body: Column(children: [
        SizedBox(
          height: screenWidth * 0.25,
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
              return MachineCard(widthArg: screenWidth, machine: const {});
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
        StreamBuilder(
            stream: _database.collection("dorms").doc(dorm).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                int len = snapshot.data!["machines"].length;
                List<dynamic> data = snapshot.data!["machines"];

                return Expanded(
                  child: ListView.builder(
                    itemCount: len,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> machineData = data[index];
                      if (machineData["type"] + '$machineData["code"]' ==
                          current) {
                        return Container();
                      }
                      int remainingTime;
                      bool isRunning = machineData["isRunning"];
                      String date = machineData["startedAt"].substring(0, 8);
                      String time = machineData["startedAt"].substring(9);

                      switch (machineData["option"]) {
                        case 0:
                          remainingTime = 45 * 60 -
                              (DateTime.now().difference(
                                      DateTime.parse('${date}T$time')))
                                  .inSeconds;
                          if (remainingTime <= 0) {
                            remainingTime = 0;
                            isRunning = false;
                          }
                          break;
                        case 1:
                          remainingTime = 50 * 60 -
                              (DateTime.now().difference(
                                      DateTime.parse('${date}T$time')))
                                  .inSeconds;
                          if (remainingTime <= 0) {
                            remainingTime = 0;
                            isRunning = false;
                          }
                          break;
                        case 2:
                          remainingTime = 80 * 60 -
                              (DateTime.now().difference(
                                      DateTime.parse('${date}T$time')))
                                  .inSeconds;
                          if (remainingTime <= 0) {
                            remainingTime = 0;
                            isRunning = false;
                          }
                          break;
                        default:
                          return Container();
                      }

                      Map<String, dynamic> machine = {
                        "type": machineData["type"],
                        "code": machineData["code"],
                        "isCurrent": false,
                        "isDisabled": machineData["isDisabled"],
                        "isRunning": isRunning,
                        "remainingTime": remainingTime,
                      };

                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.08),
                        child: MachineCard(
                            widthArg: screenWidth, machine: machine),
                      );
                    },
                  ),
                );
              } else {
                return Container();
              }
            }),
      ]),
    );
  }
}
