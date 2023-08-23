
import 'dart:async';

import 'package:firstapp/model/authentication.dart';
import 'package:firstapp/provider/information_default.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<bool> checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final authClient =
    Provider.of<FirebaseAuthProvider>(context, listen: false);
    final informationProvider = Provider.of<InformationProvider>(context, listen: false);
    bool isLogin = prefs.getBool('isLogin') ?? false;
    print("로그인 상태 : " + isLogin.toString());
    if (isLogin) {
      String? email = prefs.getString('email');
      String? password = prefs.getString('password');
      print("저장된 정보로 로그인 재시도");
      await authClient.loginWithEmail(email!, password!).then((loginStatus) {
        if (loginStatus == AuthStatus.loginSuccess) {
          print("로그인 성공");

        } else {
          print("로그인 실패");
          isLogin = false;
          prefs.setBool('isLogin', false);
        }
      });
    }
    return isLogin;
  }

  void moveScreen() async {
    await checkLogin().then((isLogin) async {
      if (isLogin) {

        final authProvider = Provider.of<FirebaseAuthProvider>(context, listen: false);
        final currentUser = authProvider.user;


        final informationProvider = Provider.of<InformationProvider>(context, listen: false);
        await informationProvider.fetchInformationListForUser(currentUser!.uid);

        Navigator.of(context).pushReplacementNamed('/main');
      } else {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1500), () {
      moveScreen();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: null,
      body: Container(
        width: screenWidth,
        height: screenHeight,
        child: Image.asset('lib/assets/Logo.png', fit: BoxFit.contain),
      ),
    );
  }
}