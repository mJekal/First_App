import 'package:flutter/material.dart';
import 'package:firstapp/model/authentication.dart';
import 'package:provider/provider.dart';
import 'package:firstapp/provider/information_default.dart';
import 'package:firstapp/screen/information_screen.dart';
import 'package:firstapp/model/information.dart';
import 'package:firstapp/screen/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  User? currentUser;

  void _onTap(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MainScreen()));
    } else if (index == 1) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ProfileScreen()));
    }
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    currentUser =
        Provider.of<FirebaseAuthProvider>(context, listen: false).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('작심 며칠?'),
        backgroundColor: Colors.blueGrey[900],
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => InformationForm()));
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Consumer<InformationProvider>(
        builder: (context, informationProvider, _) {
          final informationList = informationProvider.informationList;

          if (informationList.isEmpty) {
            return const Center(
              child: Text(
                '목표를 추가해주세요.',
                style: TextStyle(fontSize: 18),
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
        backgroundColor: Colors.blueGrey[900],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[400],
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
          color: Colors.white,
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
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  promise,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  dDay,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blueGrey[700],
                  ),
                ),
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
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                promise,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                final informationProvider =
                    Provider.of<InformationProvider>(context, listen: false);
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
