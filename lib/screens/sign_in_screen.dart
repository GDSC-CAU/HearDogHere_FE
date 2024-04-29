import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return const SignInForm();
  }
}

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  Future setLogin() async {
    // 로그인 상태를 저장
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogin', true);
  }

  bool saving = false;
  final _authentication = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6D71D2), Color(0xFF202475)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 40),
              Container(
                width: MediaQuery.of(context).size.width * 0.87, // 큰 박스 크기
                decoration: BoxDecoration(
                    color: const Color(0xFF6D71D2).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20), // 큰 박스 모서리 둥글게
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 3,
                          spreadRadius: 3,
                          offset: const Offset(0, 1))
                    ]),
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EMAIL',
                        style: TextStyle(
                          fontFamily: 'silkscreen',
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          // 패딩 조정
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.lightBlue),
                          ),
                        ),
                        onChanged: (value) {
                          email = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter your email.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 7),
                      Text(
                        'PASSWORD',
                        style: TextStyle(
                          fontFamily: 'silkscreen',
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.lightBlue),
                          ),
                        ),
                        onChanged: (value) {
                          password = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter your password.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 50),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 130,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(150),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(2.5, 2),
                                blurRadius: 0,
                                spreadRadius: -3,
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  final currentUser = await _authentication
                                      .signInWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );
                                  if (currentUser.user != null) {
                                    _formKey.currentState!.reset();
                                    FocusScope.of(context).unfocus();
                                    setLogin();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomePage(),
                                      ),
                                    );
                                  } else {
                                    print("로그인 실패: 사용자 정보가 없습니다.");
                                  }
                                } catch (e, stackTrace) {
                                  print("로그인 실패: $e");
                                  print("스택 트레이스: $stackTrace");
                                }
                              }
                            },
                            child: Text(
                              'SIGN IN',
                              style: TextStyle(
                                fontFamily: 'silkscreen',
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 7),
                                primary: Color(0xFF6D71D2).withOpacity(0.8),
                                elevation: 5),
                          ),
                        ),
                      ),
                    ],
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
