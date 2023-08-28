import 'package:firstapp/model/authentication.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/provider/information_default.dart';
import 'package:firstapp/model/information.dart';
import 'package:provider/provider.dart';
import 'package:firstapp/configs/color_styles.dart';
import 'package:firstapp/configs/text_style.dart';

class InformationForm extends StatefulWidget {
  @override
  _InformationFormState createState() => _InformationFormState();
}

class _InformationFormState extends State<InformationForm> {
  final _formKey = GlobalKey<FormState>();
  String? _goal;
  String? _promise;
  late DateTime _selectedDate;

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String dDay = 'D+${DateTime.now().difference(_selectedDate).inDays + 1}';

      final authProvider =
          Provider.of<FirebaseAuthProvider>(context, listen: false);

      if (authProvider.user != null) {
        final informationProvider =
            Provider.of<InformationProvider>(context, listen: false);

        informationProvider.addInformation(
          Information(
            goal: _goal,
            promise: _promise,
            dDay: dDay,
          ),
          authProvider.user!.uid,
        );
      }

      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.blueGrey,
              accentColor: ColorStyle.blueGrey_900,
            ),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
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
        title: const Text('작심 며칠?'),
        centerTitle: true,
        backgroundColor: ColorStyle.blueGrey_900,
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
                  color: ColorStyle.blueGrey_900,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: '목표',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                style: Styles.size18,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '목표를 입력하세요';
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
                style: Styles.size18,
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
                  backgroundColor: ColorStyle.blueGrey_900,
                  textStyle: Styles.size18,
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
