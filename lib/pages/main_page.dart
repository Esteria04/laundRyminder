import 'package:card_loading/card_loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:laundryminder/utils/prefs.dart';
import 'package:laundryminder/widgets/machines/add_new_card.dart';
import 'package:laundryminder/widgets/machines/machine_card.dart';
import 'package:laundryminder/widgets/title_text.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String dorm = Prefs.getStringValue("dorm");
  late Stream stream;

  @override
  void initState() {
    stream =
        FirebaseFirestore.instance.collection("dorms").doc(dorm).snapshots();
    super.initState();
  }

  Map<String, dynamic> cardBuilder(
      Map<String, dynamic> machine, bool isCurrent) {
    int? remainingTime;
    bool isRunning = machine["isRunning"];
    Timestamp timestamp = machine["startedAt"];
    DateTime startedAt = timestamp.toDate();
    switch (machine["option"]) {
      case 0:
        remainingTime =
            45 * 6 - (DateTime.now().difference(startedAt)).inSeconds;
        break;
      case 1:
        remainingTime =
            50 * 6 - (DateTime.now().difference(startedAt)).inSeconds;
        break;
      case 2:
        remainingTime =
            80 * 6 - (DateTime.now().difference(startedAt)).inSeconds;
        break;
    }

    if (remainingTime! <= 0) {
      remainingTime = 0;
      isRunning = false;
    }

    return {
      "type": machine["type"],
      "code": machine["code"],
      "isCurrent": isCurrent,
      "isDisabled": machine["isDisabled"],
      "isRunning": isRunning,
      "remainingTime": remainingTime,
    };
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: StreamBuilder(
              stream: stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var machines = snapshot.data!["machines"];
                  if (Prefs.getMapValue("current").isEmpty) {
                    return const AddNewCard();
                  }
                  for (int i = 0; i < machines.length; i++) {
                    if (machines[i]["type"] ==
                            Prefs.getMapValue("current")["type"] &&
                        machines[i]["code"] ==
                            Prefs.getMapValue("current")["code"]) {
                      return MachineCard(
                          machine: cardBuilder(machines[i], true));
                    }
                  }
                }
                return const AddNewCard();
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: screenWidth * 0.08,
                right: screenWidth * 0.08,
                top: screenWidth * 0.04,
              ),
              child: TitleText(
                data: "Machines",
                fontSize: screenWidth * 0.07,
              ),
            ),
          ],
        ),
        StreamBuilder(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                int len = snapshot.data!["machines"].length;
                List<dynamic> data = snapshot.data!["machines"];

                return Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: len,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> machineData = data[index];
                      Map<String, dynamic> machine =
                          cardBuilder(machineData, false);
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.08,
                        ),
                        child: MachineCard(machine: machine),
                      );
                    },
                  ),
                );
              } else {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CardLoading(
                        width: screenWidth * 0.84,
                        height: screenWidth * 0.3,
                        animationDuration: const Duration(microseconds: 400),
                        borderRadius:
                            BorderRadius.circular(screenWidth * 0.045),
                        margin: const EdgeInsets.only(bottom: 10),
                      ),
                      CardLoading(
                        width: screenWidth * 0.44,
                        height: screenWidth * 0.1,
                        animationDuration: const Duration(microseconds: 400),
                        borderRadius:
                            BorderRadius.circular(screenWidth * 0.045),
                        margin: const EdgeInsets.only(bottom: 10),
                      ),
                      CardLoading(
                        width: screenWidth * 0.84,
                        height: screenWidth * 0.3,
                        animationDuration: const Duration(microseconds: 400),
                        borderRadius:
                            BorderRadius.circular(screenWidth * 0.045),
                        margin: const EdgeInsets.only(bottom: 10),
                      ),
                      CardLoading(
                        width: screenWidth * 0.44,
                        height: screenWidth * 0.1,
                        animationDuration: const Duration(microseconds: 400),
                        borderRadius:
                            BorderRadius.circular(screenWidth * 0.045),
                        margin: const EdgeInsets.only(bottom: 10),
                      ),
                    ],
                  ),
                );
              }
            }),
      ]),
    );
  }
}
