import 'package:flutter/material.dart';
import 'package:laundryminder/widgets/machines/current_dryer.dart';
import 'package:laundryminder/widgets/machines/current_washer.dart';
import 'package:laundryminder/widgets/machines/dryer.dart';
import 'package:laundryminder/widgets/machines/washer.dart';

class MachineCard extends StatelessWidget {
  const MachineCard({
    super.key,
    required this.machine,
  });

  final Map<String, dynamic> machine;

  @override
  Widget build(BuildContext context) {
    if (machine["isCurrent"]) {
      return machine["type"] == "Washer"
          ? CurrentWasher(machine: machine)
          : CurrentDryer(machine: machine);
    } else {
      return machine["type"] == "Washer"
          ? Washer(machine: machine)
          : Dryer(machine: machine);
    }
  }
}
