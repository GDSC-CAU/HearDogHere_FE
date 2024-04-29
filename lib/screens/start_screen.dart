import 'package:flutter/material.dart';
import 'sign_in_screen.dart';
import 'package:space_dog/screens/sign_up_screens/sign_up_screen.dart';
import 'package:starsview/starsview.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

List<List<String>> description = [
  [
    'As there is no air to vibrate, you can\'t hear anything in space',
    'assets/images/description/hello.png'
  ],
  [
    'We\'ll help you to raise dogs in such conditions',
    'assets/images/description/astronaut_and_dog.png'
  ],
  [
    'We\'ll let you know when your dog barks or breaks something',
    'assets/images/dog_state/dog_bark.png'
  ],
  [
    'We\'ll alert you when your dog escapes',
    'assets/images/description/escape.png'
  ]
];

class _StartState extends State<Start> {
  final PageController controller = PageController(initialPage: 0);
  int currentPage = 0;

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
              SizedBox(height: 50),
              Image.asset(
                'assets/images/title.png',
                width: MediaQuery.of(context).size.width * 0.8,
              ),
              SizedBox(height: 30),
              Container(
                // 카드 슬라이더
                height: MediaQuery.of(context).size.height * 0.5,
                child: PageView.builder(
                    controller: controller,
                    itemCount: 4,
                    onPageChanged: (page) {
                      setState(() {
                        currentPage = page;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Container(
                            //padding: const EdgeInsets.fromLTRB(20, 15, 15, 15),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: const Color(0xFF6D71D2).withOpacity(0.4),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 3,
                                      spreadRadius: 3,
                                      offset: const Offset(0, 1))
                                ]),
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Image.asset(
                                    description[currentPage][1],
                                    height:
                                        MediaQuery.of(context).size.width * 0.6,
                                    // width:
                                    //     MediaQuery.of(context).size.width * 0.7,
                                    //fit: BoxFit.contain,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(7.0),
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      description[currentPage][0],
                                      style: TextStyle(
                                          height: 1.2,
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontStyle: FontStyle.italic,
                                          fontFamily: 'silkscreen'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 5),
                            child: StarsView(
                              fps: 60,
                            ),
                          ),
                        ],
                      );
                    }),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (num i = 0; i < 4; i++)
                    Container(
                      margin: const EdgeInsets.all(3),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i == currentPage
                              ? const Color(0xffffffffff).withOpacity(0.7)
                              : Colors.white.withOpacity(.2)),
                    ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // sign-in button
                  Container(
                    height: 55,
                    width: 170, // 로그인 버튼 너비
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), // 그림자 모서리 둥글게
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
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    SignIn(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              var begin = Offset(-1.0, 0.0); // 오른쪽에서 슬라이드
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
                          fontFamily: 'silkscreen',
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        primary: Color(0xFF6D71D2).withOpacity(0.5),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          //side: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  //  sign-Up button
                  Container(
                    height: 55,
                    width: 170,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
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
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    SignUp(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
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
                          fontFamily: 'silkscreen',
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 8), // 회원가입 버튼 높이
                        primary: Color(0xFF6D71D2).withOpacity(0.5),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
