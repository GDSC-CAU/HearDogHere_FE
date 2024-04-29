import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_dog/screens/home_screen.dart';

import 'enter_dog_name_screen.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return const SignupForm();
  }
}

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _authentication = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool saving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            // 배경 그라디언트
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6D71D2), Color(0xFF202475)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 40),
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
                        // ID
                        const Text(
                          'EMAIL',
                          style: TextStyle(
                            fontFamily: 'silkscreen',
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 0),
                        TextFormField(
                          obscureText: false, // 입력 안 보이게
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            // 비밀번호 폼 높이, 너비
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              // 포커스 됐을 때의 테두리
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  const BorderSide(color: Colors.lightBlue),
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
                        const SizedBox(height: 10),

                        // PW
                        const Text(
                          'PASSWORD',
                          style: TextStyle(
                            fontFamily: 'silkscreen',
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 0),
                        TextFormField(
                          obscureText: true, // 입력 안 보이게
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            // 비밀번호 폼 높이, 너비
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              // 포커스 됐을 때의 테두리
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  const BorderSide(color: Colors.lightBlue),
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
                        const SizedBox(height: 50),

                        // NEXT
                        Center(
                          child: Container(
                            width: 130, // 로그인 버튼 너비
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(150),
                              // 그림자 모서리 둥글게
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(2.5, 2), // 그림자 위치
                                  blurRadius: 0, // 그림자 스프레드
                                  spreadRadius: -3, // 그림자 크기
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    setState(() {
                                      saving = true;
                                    });
                                    final newUser = await _authentication
                                        .createUserWithEmailAndPassword(
                                      email: email,
                                      password: password,
                                    );
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(newUser.user!.uid)
                                        .set({
                                      'email': email,
                                    });
                                    if (newUser.user != null) {
                                      // 회원가입 성공
                                      print("success");
                                      _formKey.currentState!.reset();
                                      if (!mounted) return;
                                      FocusScope.of(context).unfocus();
                                      Navigator.push(context, _createRoute());
                                    } else {
                                      // 회원가입 실패 처리
                                      print("회원가입 실패: 사용자 정보가 없습니다.");
                                    }
                                  } catch (e, stackTrace) {
                                    print("회원가입 실패: $e");
                                    print("스택 트레이스: $stackTrace");
                                  }
                                  setState(() {
                                    saving = false;
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 7),
                                  primary: Color(0xFF6D71D2).withOpacity(0.8),
                                  elevation: 5),
                              child: Text(
                                'REGISTER',
                                style: TextStyle(
                                  fontFamily: 'silkscreen',
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
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
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => EnterDogName(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // 현재 화면에 대한 슬라이드 효과
        var currentScreenSlide = Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-1.0, 0.0),
        ).animate(animation);

        // 새 화면에 대한 슬라이드 효과
        var newScreenSlide = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation);

        return Stack(
          children: <Widget>[
            SlideTransition(
              position: currentScreenSlide,
              child: const SignupForm(), // 현재 화면
            ),
            SlideTransition(
              position: newScreenSlide,
              child: child, // 새 화면
            ),
          ],
        );
      },
      transitionDuration:
          const Duration(milliseconds: 500), // 현재 -> 새로운 페이지 전환 시간
    );
  }
}
