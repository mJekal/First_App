import 'package:firstapp/configs/text_style.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/model/authentication.dart';
import 'package:provider/provider.dart';
import 'package:firstapp/provider/information_default.dart';
import 'package:firstapp/screen/information_screen.dart';
import 'package:firstapp/model/information.dart';
import 'package:firstapp/screen/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstapp/configs/color_styles.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  void _onTap(int index) {
    if (index == 0) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen()));
    } else if (index == 1) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<FirebaseAuthProvider>(context, listen: false);
    final currentUser = authProvider.user;

    final informationProvider = Provider.of<InformationProvider>(context);
    informationProvider.fetchInformationListForUser(currentUser!.uid); // 수정된 부분

    return Scaffold(
      appBar:  AppBar(
        title: const Text('작심 며칠?'),
        backgroundColor: ColorStyle.blueGrey_900,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => InformationForm()));
        },
        child: const Icon(Icons.add),
        backgroundColor: ColorStyle.blueGrey_900,
      ),
      body:Consumer<InformationProvider>(
        builder: (context, informationProvider, _) {
          informationProvider.fetchInformationListForUser(authProvider.user!.uid);
          final informationList = informationProvider.informationList;

          if (informationList.isEmpty) {
            return const Center(
              child: Text(
                '목표를 추가해주세요.',
                style: Styles.size18,
              ),
            );
          }

          return ListView.separated(
            itemCount: informationList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return _listItem(context, informationList[index], index);
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onTap,
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




  Widget _listItem(BuildContext context, Information information, int index) {
    final goal = information.goal ?? '';
    final promise = information.promise ?? '';
    final dDay = information.dDay ?? '';

    return GestureDetector(
      onTap: () {
        _showDialog(context, information, index, promise);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ColorStyle.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              goal,
              style: Styles.bold18),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(promise, style: Styles.bold14),
                Text(dDay, style: Styles.size16c),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, Information information, int index,
      String promise) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('결심'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${information.goal} 결심 한지? ${information.dDay}',
                  style: Styles.bold18),
              const SizedBox(height: 8),
              Text(promise, style: Styles.bold18),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                final informationProvider = Provider.of<InformationProvider>(
                    context, listen: false);
                informationProvider.deleteInformation(index);
                Navigator.pop(context);
              },
              child: const Text('삭제'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}