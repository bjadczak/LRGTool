import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lrgtool/misc/auth.dart';
import 'package:lrgtool/pages/home_page.dart';

import 'package:email_validator/email_validator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true;
  bool _passwordVisible = false;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerPasswordRepeat =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Future<void> signInWithEmailAndPassword() async {
  //   if (_formKey.currentState!.validate()) {
  //     try {
  //       await Auth().signInWithEmailAndPassword(
  //         email: _controllerEmail.text,
  //         password: _controllerPassword.text,
  //       );
  //     } on FirebaseAuthException catch (e) {
  //       showDialog(
  //         context: context,
  //         builder: (context) {
  //           return AlertDialog(
  //             title: const Text("Warning!"),
  //             content: Text(e.message ??
  //                 "Something went wrong, can't retrive error message"),
  //             actions: [
  //               ElevatedButton(
  //                   onPressed: () => Navigator.pop(context),
  //                   child: const Text('OK')),
  //             ],
  //           );
  //         },
  //       );
  //     }
  //   }
  // }

  // Future<void> createUserWithEmailAndPassword() async {
  //   if (_formKey.currentState!.validate()) {
  //     try {
  //       await Auth().createUserWithEmailAndPassword(
  //         email: _controllerEmail.text,
  //         password: _controllerPassword.text,
  //       );
  //     } on FirebaseAuthException catch (e) {
  //       showDialog(
  //         context: context,
  //         builder: (context) {
  //           return AlertDialog(
  //             title: const Text("Warning!"),
  //             content: Text(e.message ??
  //                 "Something went wrong, can't retrive error message"),
  //             actions: [
  //               ElevatedButton(
  //                   onPressed: () => Navigator.pop(context),
  //                   child: const Text('OK')),
  //             ],
  //           );
  //         },
  //       );
  //     }
  //   }
  // }

  Widget _passwordCreateEntryFiled() {
    return TextFormField(
      obscureText: !_passwordVisible,
      controller: _controllerPassword,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        suffixIcon: IconButton(
          icon: Icon(
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: Theme.of(context).primaryColorDark,
          ),
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter password";
        } else if (value.length < 6) {
          return "Password needs to be at least 6 charachters";
        }
        return null;
      },
    );
  }

  Widget _passwordCreateRepeatEntryFiled() {
    return TextFormField(
      obscureText: !_passwordVisible,
      controller: _controllerPasswordRepeat,
      decoration: const InputDecoration(
        labelText: "Repeat password",
        hintText: 'Repeat your password',
      ),
      validator: (value) {
        if (value != _controllerPassword.text) {
          return "Passwords do not match";
        }
        return null;
      },
    );
  }

  Widget _emailEntryField() {
    return TextFormField(
      controller: _controllerEmail,
      decoration: const InputDecoration(
          labelText: "e-mail", hintText: 'Enter your e-mail'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Pleas enter email";
        } else if (!EmailValidator.validate(value)) {
          return "Not a valid email";
        }
        return null;
      },
    );
  }

  Widget _passwordEntryField() {
    return TextField(
      obscureText: !_passwordVisible,
      controller: _controllerPassword,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        suffixIcon: IconButton(
          icon: Icon(
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: Theme.of(context).primaryColorDark,
          ),
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
      ),
    );
  }

  Widget _submitButton() {
    return Container(
      margin: const EdgeInsets.only(top: 15.0),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Warning!"),
                  content: const Text(
                      "For GH Pages, Firebase database and auth is turned off"),
                  actions: [
                    ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK')),
                  ],
                );
              },
            );
          }
        },
        child: Text(isLogin ? 'Login' : 'Register'),
      ),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(isLogin ? 'Register instead' : 'Login instead'),
    );
  }

  Widget _getLoginContent() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _emailEntryField(),
          _passwordEntryField(),
          _submitButton(),
          _loginOrRegisterButton(),
          TextButton(
            onPressed: () {
              setState(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              });
            },
            child: const Text('Offline'),
          ),
        ],
      ),
    );
  }

  Widget _getRegisterContent() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _emailEntryField(),
          _passwordCreateEntryFiled(),
          _passwordCreateRepeatEntryFiled(),
          _submitButton(),
          _loginOrRegisterButton(),
          TextButton(
            onPressed: () {
              setState(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              });
            },
            child: const Text('Offline'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(minWidth: 200, maxWidth: 400),
          padding: const EdgeInsets.all(20),
          child: isLogin ? _getLoginContent() : _getRegisterContent(),
        ),
      ),
    );
  }
}
