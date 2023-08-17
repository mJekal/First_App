import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class Information {
  String? goal;
  String? promise;
  String? dDay;

  Information({this.goal, this.promise, this.dDay});
}

class _MainScreenState extends State<MainScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Information> _informationList = [];

  Future<void> _informationView(Information info) async {
    try {
      await _firestore.collection('information').add({
        'goal': info.goal,
        'promise': info.promise,
        'dDay': info.dDay,
      });
      setState(() {
        _informationList.add(info);
      });
    } catch (error) {
      print('문서 추가 오류: $error');
    }
  }

  Future<void> _initializeInformationList() async {
    try {
      final QuerySnapshot snapshot =
      await _firestore.collection('information').get();
      final List<Information> infoList = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Information(
          goal: data['goal'],
          promise: data['promise'],
          dDay: data['dDay'],
        );
      }).toList();

      setState(() {
        _informationList = infoList;
      });
    } catch (error) {
      print('문서 검색 오류: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeInformationList();
  }





  void _navigateToForm() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InformationForm(),
      ),
    );
    if (result != null && result is Information) {
      _informationView(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('작심 며칠?'),
        backgroundColor: Colors.blueGrey[900],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToForm,
        child: const Icon(Icons.add),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: ListView.separated(
        itemCount: _informationList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          if (_informationList.isEmpty) {
            return const Center(
              child: Text(
                '목표를 추가 해주세요.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }
          return _listItem(index);
        },
      ),
    );
  }

  Widget _listItem(int index) {
    final goal = _informationList[index].goal ?? '';
    final promise = _informationList[index].promise ?? '';
    final dDay = _informationList[index].dDay ?? '';
    return ListTile(
      contentPadding: EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      tileColor: Colors.grey[200],
      // Light gray color for tiles
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
                    setState(() {
                      _informationList
                          .removeAt(index); // Remove the selected goal
                      Navigator.pop(context); // Close the AlertDialog
                    });
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

class InformationForm extends StatefulWidget {
  @override
  _InformationFormState createState() => _InformationFormState();
}

class _InformationFormState extends State<InformationForm> {
  final _formKey = GlobalKey<FormState>();
  String? _goal;
  String? _promise;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String dDay = 'D+${DateTime.now().difference(_selectedDate).inDays + 1}';
      Navigator.pop(
        context,
        Information(
          goal: _goal,
          promise: _promise,
          dDay: dDay,
        ),
      );
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('결심 한지?'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _selectDate,
                child: Icon(
                  Icons.calendar_month,
                  size: 48,
                  color: Colors.blueGrey[900],
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: '목표',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                style: const TextStyle(fontSize: 18),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '목표를 입력 하세요';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    _goal = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: '다짐 한마디',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                style: const TextStyle(fontSize: 18),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '다짐 한마디를 입력하세요';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    _promise = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveForm,
                child: const Text('등록'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey[900],
                  textStyle: const TextStyle(fontSize: 18),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

