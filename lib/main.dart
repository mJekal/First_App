import 'package:firstapp/model/authentication.dart';
import 'package:firstapp/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firstapp/provider/information_default.dart';
import 'package:firstapp/screen/main_screen.dart';
import 'package:firstapp/screen/login_screen.dart';
import 'package:firstapp/screen/register_screen.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FirebaseAuthProvider()),
        ChangeNotifierProvider(create: (_) => InformationProvider()),
      ],
      child: MaterialApp(
        title: '작심 며칠?',
        routes: {
          '/': (context) => SplashScreen(),
          '/login': (context) => LoginScreen(),
          '/main': (context) => MainScreen(),
          '/register': (context) => RegisterScreen(),
        },
        initialRoute: '/',
      ),
    );
  }
}
