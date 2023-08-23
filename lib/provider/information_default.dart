import 'package:flutter/material.dart';
import 'package:firstapp/model/information.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InformationProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Information> _informationList = [];

  List<Information> get informationList => _informationList;

  Information _informationFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Information.fromMap(data);
  }

  Future<int> getGoalCountForUser(String userId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('information')
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs.length;
    } catch (error) {
      print('Error fetching goal count: $error');
      return 0;
    }
  }



  Future<void> fetchInformationList() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('information')
          .orderBy('createdAt', descending: false)
          .get();

      final List<Information> infoList = snapshot.docs.map((doc) {
        return Information.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      _informationList = infoList;
      notifyListeners();
    } catch (error) {
      print('문서 검색 오류: $error');
    }
  }


  Future<void> fetchInformationListForUser(String userId) async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('information')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: false)
          .get();

      final List<Information> infoList = snapshot.docs.map((doc) {
        return Information.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      _informationList = infoList;
      notifyListeners();
    } catch (error) {
      print('문서 검색 오류: $error');
    }
  }


  Future<void> addInformation(Information info, String userId) async {
    try {
      final data = info.toMap();

      data['createdAt'] = FieldValue.serverTimestamp();
      data['userId'] = userId; // Add the user ID to the data

      final docRef = await _firestore.collection('information').add(data);

      final addedInfo = Information(
        goal: info.goal,
        promise: info.promise,
        dDay: info.dDay,
      );
      _informationList.add(addedInfo);

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

  Future<void> saveInformationToFirestore(Information info) async {
    final docRef = _firestore.collection('information').doc(info.goal);

    final data = {
      'goal': info.goal,
      'promise': info.promise,
      'dDay': info.dDay,
    };

    await docRef.set(data);
  }

  Stream<List<Information>> readInformationStream() {
    return _firestore.collection('information').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return _informationFromSnapshot(doc);
      }).toList();
    });
  }
}

