import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Map<String, dynamic>> _informationList = [];

  void _informationView(String? goal, String? promise, DateTime selectedDate) {
    Map<String, dynamic> info = {
      'goal': goal ?? '없음',
      'promise': promise ?? '없음',
      'dDay': 'D+${DateTime.now().difference(selectedDate).inDays + 1}',
    };

    setState(() {
      _informationList.add(info);
    });
  }

  void _navigateToForm() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InformationForm(),
      ),
    );

    if (result != null && result is Map) {
      _informationView(result['goal'], result['promise'], result['selectedDate']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('결심 한지?'),
        backgroundColor: Colors.blueGrey[900],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToForm,
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: _informationList.isEmpty
          ? Center(
        child: Text(
          '목표를 추가 해주세요.',
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.separated(
        itemCount: _informationList.length,
        separatorBuilder: (context, index) => SizedBox(height: 16),
        itemBuilder: (context, index) {
          final goal = _informationList[index]['goal'];
          final promise = _informationList[index]['promise'];
          final dDay = _informationList[index]['dDay'];

          return Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
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
                ),
                SizedBox(width: 16),
                Text(
                  dDay,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          );
        },
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
      Navigator.pop(
        context,
        {'goal': _goal, 'promise': _promise, 'selectedDate': _selectedDate},
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
        title: Text('결심 한지?'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
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
              SizedBox(height: 24),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '목표',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 18),
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
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '다짐 한마디',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 18),
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
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text('등록'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey[900],
                  textStyle: TextStyle(fontSize: 18),
                  padding: EdgeInsets.symmetric(
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