import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firstapp/model/authentication.dart';
import 'package:firstapp/model/login.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginModel(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("로그인"),
          centerTitle: true,
          backgroundColor: Colors.blueGrey[900],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const SizedBox(height: 20),
              const Email(),
              const Password(),
              const SizedBox(height: 20),
              const LoginButton(),
              const SizedBox(height: 16),
              Text(
                '또는',
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(height: 16),
              const RegisterButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class Email extends StatelessWidget {
  const Email({super.key});

  @override
  Widget build(BuildContext context) {
    final loginField = Provider.of<LoginModel>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: TextField(
        onChanged: (email) {
          loginField.setEmail(email);
        },
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          labelText: '이메일',
          prefixIcon: Icon(Icons.email),
        ),
      ),
    );
  }
}

class Password extends StatelessWidget {
  const Password({super.key});

  @override
  Widget build(BuildContext context) {
    final loginField = Provider.of<LoginModel>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: TextField(
        onChanged: (password) {
          loginField.setPassword(password);
        },
        obscureText: true,
        decoration: const InputDecoration(
          labelText: '비밀번호',
          prefixIcon: Icon(Icons.lock),
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    final authClient =
        Provider.of<FirebaseAuthProvider>(context, listen: false);
    final loginField = Provider.of<LoginModel>(context, listen: false);
    return SizedBox(
      width: 200,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed: () async {
          await authClient
              .loginWithEmail(loginField.email, loginField.password)
              .then((loginStatus) {
            if (loginStatus == AuthStatus.loginSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text('${authClient.user!.email!}님 환영합니다!')),
                );
              Navigator.pushReplacementNamed(context, '/main');
            } else {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('로그인에 실패했습니다.')),
                );
            }
          });
        },
        child: const Text('로그인'),
      ),
    );
  }
}

class RegisterButton extends StatelessWidget {
  const RegisterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/register');
      },
      child: Text(
        '회원가입',
        style: TextStyle(color: Colors.blueGrey[900], fontSize: 16),
      ),
    );
  }
}
