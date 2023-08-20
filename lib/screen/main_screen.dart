import 'package:flutter/material.dart';
import 'package:firstapp/provider/information_default.dart';
import 'package:firstapp/screen/information_screen.dart';
import 'package:firstapp/model/information.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final informationProvider = Provider.of<InformationProvider>(context);
    informationProvider.fetchInformationList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('작심 며칠?'),
        backgroundColor: Colors.blueGrey[900],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => InformationForm()));
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Consumer<InformationProvider>(
        builder: (context, informationProvider, _) {
          final informationList = informationProvider.informationList;

          if (informationList.isEmpty) {
            return Center(
              child: Text(
                '목표를 추가 해주세요.',
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
    );
  }

  Widget _listItem(BuildContext context, Information information, int index) {
    final goal = information.goal ?? '';
    final promise = information.promise ?? '';
    final dDay = information.dDay ?? '';

    return ListTile(
      contentPadding: EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      tileColor: Colors.grey[200],
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('결심'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 64,
                      child: Text(
                        goal + ' 결심 한지? ' + dDay,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      promise,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    final informationProvider = Provider.of<InformationProvider>(context, listen: false);
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
      },
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            goal,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            promise,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      trailing: Text(
        dDay,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}
