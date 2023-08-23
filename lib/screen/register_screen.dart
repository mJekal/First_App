import 'package:firstapp/model/authentication.dart';
import 'package:firstapp/model/register.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('회원가입'),
          backgroundColor: Colors.blueGrey[900],
        ),
        body: const SingleChildScrollView(
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
              RegisterButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class Email extends StatelessWidget {
  const Email({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final registerField = Provider.of<RegisterModel>(context, listen: false);
    return TextField(
      onChanged: (email) {
        registerField.setEmail(email);
      },
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
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
    final registerField = Provider.of<RegisterModel>(context, listen: false);
    return TextField(
      onChanged: (password) {
        registerField.setPassword(password);
      },
      obscureText: true,
      decoration: const InputDecoration(
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
    final registerField = Provider.of<RegisterModel>(context);
    return TextField(
      onChanged: (password) {
        registerField.setPasswordConfirm(password);
      },
      obscureText: true,
      decoration: InputDecoration(
          labelText: '비밀번호 확인',
          errorText: registerField.password != registerField.passwordConfirm ?
          '비밀번호가 일치하지 않습니다.' : null,
        border: const OutlineInputBorder(),

      ),
    );
  }
}







class RegisterButton extends StatelessWidget {
  const RegisterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authClient = Provider.of<FirebaseAuthProvider>(context, listen: false);
    final registerField = Provider.of<RegisterModel>(context, listen: false);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15),
        backgroundColor: Colors.blueGrey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      onPressed: () async {
        await authClient
            .registerWithEmail(registerField.email, registerField.password)
            .then((registerStatus) {
          if (registerStatus == AuthStatus.registerSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('회원가입이 완료되었습니다.')),
              );
            Navigator.of(context).pushReplacementNamed('/login'); // Navigate to login screen
          } else {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('회원가입을 실패했습니다.')),
              );
          }
        });
      },
      child: const Text(
        '회원가입',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
