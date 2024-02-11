import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:laundryminder/firebase_options.dart';
import 'package:laundryminder/pages/entry_page.dart';
import 'package:laundryminder/utils/prefs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Prefs.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: EntryPage(),
    );
  }
}
