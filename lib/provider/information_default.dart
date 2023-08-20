import 'package:flutter/material.dart';
import 'package:firstapp/model/information.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InformationProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Information> _informationList = [];

  List<Information> get informationList => _informationList;

  Future<void> fetchInformationList() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('information').get();
      final List<Information> infoList = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Information(
          goal: data['goal'],
          promise: data['promise'],
          dDay: data['dDay'],
        );
      }).toList();

      _informationList = infoList;
      notifyListeners();
    } catch (error) {
      print('문서 검색 오류: $error');
    }
  }

  Future<void> addInformation(Information info) async {
    try {
      await _firestore.collection('information').add({
        'goal': info.goal,
        'promise': info.promise,
        'dDay': info.dDay,
      });
      _informationList.add(info);
      notifyListeners();
    } catch (error) {
      print('문서 추가 오류: $error');
    }
  }

  Future<void> deleteInformation(int index) async {
    try {
      await _firestore
          .collection('information')
          .where('goal', isEqualTo: _informationList[index].goal)
          .get()
          .then((snapshot) {
        snapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });

      _informationList.removeAt(index);
      notifyListeners();
    } catch (error) {
      print('문서 삭제 오류: $error');
    }
  }
}
