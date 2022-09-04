import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../shared/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String message = '';
  bool isLogin = true;
  bool isPasswordShown = false;
  bool obscurePassword = true;
  var txtUserName = TextEditingController();
  var txtPassword = TextEditingController();
  var formKey = GlobalKey<FormState>();

  // firebase auth
  late FirebaseAuthentication auth;

  @override
  void initState() {
    Firebase.initializeApp().whenComplete(() {
      auth = FirebaseAuthentication();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
        actions: [
          IconButton(
            onPressed: () {
              auth.logout().then((value) {
                if (value) {
                  setState(() {
                    message = 'User Logged Out';
                  });
                } else {
                  message = 'Unable to log out';
                }
              });
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(36.0),
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  userInput(),
                  passwordInput(),
                  btnMain(),
                  btnSecondary(),
                  txtMessage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget userInput() => Padding(
        padding: const EdgeInsetsDirectional.only(
          top: 128,
        ),
        child: TextFormField(
          controller: txtUserName,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'User Name',
            icon: Icon(
              Icons.verified_user,
            ),
          ),
          validator: (value) {
            if (value == null) {
              return 'User Name is required';
            }
            return null;
          },
        ),
      );

  Widget passwordInput() => Padding(
        padding: const EdgeInsetsDirectional.only(
          top: 24,
        ),
        child: TextFormField(
          controller: txtPassword,
          keyboardType: TextInputType.visiblePassword,
          obscureText: obscurePassword,
          decoration:  InputDecoration(
            hintText: 'password',
            icon: const Icon(
              Icons.enhanced_encryption,
            ),
            suffixIcon: IconButton(
              onPressed: (){
                setState(() {
                  isPasswordShown = !isPasswordShown;
                  obscurePassword = !obscurePassword;
                });
              },
             icon: Icon(
            isPasswordShown ? Icons.visibility : Icons.visibility_off,
             ),
            ),
          ),
          validator: (value) {
            if (value == null) {
              return 'Password is required';
            } else {
              return '';
            }
          },
        ),
      );

  Widget btnMain() {
    String btnText = isLogin ? 'Log in' : 'Sign up';
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 10),
      child: Container(
        height: 60.0,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Theme.of(context).primaryColorLight),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
                side: const BorderSide(
                  color: Colors.red,
                ),
              ),
            ),
          ),
          onPressed: () {
            var userId = '';
            // if(formKey.currentState!.validate()){
            if (isLogin) {
              auth.login(txtUserName.text, txtPassword.text).then((value) {
                if (value == null) {
                  setState(() {
                    message = 'login Error';
                  });
                } else {
                  userId = value;
                  setState(() {
                    message = 'user $userId successfully logged in';
                  });
                }
              });
            } else {
              auth.createUser(txtUserName.text, txtPassword.text).then((value) {
                if (value == null) {
                  setState(() {
                    message = 'Registration Error';
                  });
                } else {
                  userId = value;
                  setState(() {
                    message = 'user $userId successfully Registered';
                  });
                }
              });
            }
            // }
          },
          child: Text(
            btnText,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget btnSecondary() {
    String buttonText = isLogin ? 'Sign up' : 'Log In';
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(
        buttonText,
      ),
    );
  }

  Widget txtMessage() => Text(
        message,
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).primaryColorDark,
          fontWeight: FontWeight.bold,
        ),
      );
}
