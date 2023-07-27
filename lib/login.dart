import 'package:flutter/material.dart';
import 'package:secomp_leitor/auth.dart';
import 'package:secomp_leitor/post_noticias.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  String email = '';
  String senha = '';

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                onSaved: (e) {
                  setState(() {
                    email = e;
                  });
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                onSaved: (s) {
                  setState(() {
                    senha = s;
                  });
                },
                obscureText: true,
              ),
              OutlinedButton(
                child: Text("Login"),
                onPressed: () {
                  _formKey.currentState.save();
                  handleSignInEmail(email, senha).whenComplete(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PostNoticias()));
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
