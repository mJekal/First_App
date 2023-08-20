import 'package:flutter/material.dart';
import 'package:firstapp/screen/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firstapp/provider/information_default.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => InformationProvider(),
      child: MaterialApp(
        title: '작심 며칠?',
        home: MainScreen(),
      ),
    );
  }
}
