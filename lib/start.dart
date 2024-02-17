import 'package:flutter/material.dart';
import 'sign_in.dart';
import 'sign_up.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 100),
              Container(
                width: 300, // 로그인 버튼 너비
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), // 그림자 모서리 둥글게
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(2.5, 2), // 그림자 위치
                      blurRadius: 0, // 그림자 스프레드
                      spreadRadius: -3, // 그림자 크기
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            SignIn(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          var begin = Offset(1.0, 0.0); // 오른쪽에서 슬라이드
                          var end = Offset.zero;
                          var curve = Curves.decelerate;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                        transitionDuration: Duration(milliseconds: 500),
                      ),
                    );
                  },
                  child: Text(
                    'SIGN UP',
                    style: TextStyle(
                        fontFamily: 'nbold',
                        fontSize: 18,
                        color: Colors.lightBlue[800]),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 8), // 로그인 버튼 높이
                    primary: Colors.white,
                    onPrimary: Colors.lightBlue[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Container(
                width: 300, // 회원가입 버튼 너비
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), // 그림자 모서리 둥글게
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(2.5, 2), // 그림자 위치
                      blurRadius: 0, // 그림자 스프레드
                      spreadRadius: -3, // 그림자 크기
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            SignUp(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          var begin = Offset(1.0, 0.0); // 오른쪽에서 슬라이드
                          var end = Offset.zero;
                          var curve = Curves.decelerate;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                        transitionDuration: Duration(milliseconds: 500),
                      ),
                    );
                  },
                  child: Text(
                    'SIGN IN',
                    style: TextStyle(
                        fontFamily: 'nbold',
                        fontSize: 18,
                        color: Colors.lightBlue[800]),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 8), // 회원가입 버튼 높이
                    primary: Colors.white,
                    onPrimary: Colors.lightBlue[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
              Image.asset(
                'assets/images/puang.png',
                width: 150,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
