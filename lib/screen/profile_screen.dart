import 'package:firstapp/configs/color_styles.dart';
import 'package:firstapp/configs/text_style.dart';
import 'package:firstapp/screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/model/authentication.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  int _currentIndex = 1;

  ProfileScreen({super.key});

  void _onTap(int index, BuildContext context) {
    if (index == 0) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.logout, color: ColorStyle.blueGrey_900),
              SizedBox(width: 8),
              Text('로그아웃', style: TextStyle(color: ColorStyle.blueGrey_900)),
            ],
          ),
          content: Text('로그아웃 하시겠습니까?'),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    final authClient = Provider.of<FirebaseAuthProvider>(
                        context,
                        listen: false);
                    await authClient.logout();
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        const SnackBar(content: Text('로그아웃 되었습니다.')),
                      );
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                  icon: Icon(Icons.logout, color: ColorStyle.white),
                  label: Text('로그아웃', style: Styles.boldwhite),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorStyle.blueGrey_900,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.cancel, color: ColorStyle.white),
                  label: Text('취소', style: Styles.boldwhite),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorStyle.blueGrey_900,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider =
        Provider.of<FirebaseAuthProvider>(context, listen: false);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필'),
        backgroundColor: ColorStyle.blueGrey_900,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: ColorStyle.blueGrey_900,
              radius: 50,
              child: const Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(user?.email ?? '사용자 이메일 없음', style: Styles.bold18c),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _showLogoutDialog(context);
              },
              child: const Text('로그아웃'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: ColorStyle.blueGrey_900,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  textStyle: Styles.bold18),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => _onTap(index, context),
        currentIndex: _currentIndex,
        backgroundColor: ColorStyle.blueGrey_900,
        selectedItemColor: ColorStyle.white,
        unselectedItemColor: ColorStyle.grey_400,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '프로필',
          ),
        ],
      ),
    );
  }
}
