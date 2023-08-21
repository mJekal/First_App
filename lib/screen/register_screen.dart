import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입 화면'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Email(),
            SizedBox(height: 20),
            Password(),
            SizedBox(height: 20),
            Password2(),
            SizedBox(height: 30),
            Register(),
          ],
        ),
      ),
    );
  }
}

class Email extends StatelessWidget {
  const Email({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (email) {},
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: '이메일',
        border: OutlineInputBorder(),
      ),
    );
  }
}

class Password extends StatelessWidget {
  const Password({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (password) {},
      obscureText: true,
      decoration: InputDecoration(
        labelText: '비밀번호',
        border: OutlineInputBorder(),
      ),
    );
  }
}

class Password2 extends StatelessWidget {
  const Password2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (password) {},
      obscureText: true,
      decoration: InputDecoration(
        labelText: '비밀번호 확인',
        border: OutlineInputBorder(),
      ),
    );
  }
}

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        primary: Colors.blueGrey[900],
      ),
      onPressed: () {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text('회원가입이 완료되었습니다.')),
          );
        Navigator.pop(context);
      },
      child: Text(
        '회원가입',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}