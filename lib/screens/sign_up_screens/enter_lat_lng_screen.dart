import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:space_dog/screens/home_screen.dart';
import 'package:space_dog/screens/loading_screen.dart';

class EnterHomeLatLng extends StatefulWidget {
  const EnterHomeLatLng({Key? key});

  @override
  State<EnterHomeLatLng> createState() => _EnterHomeLatLngState();
}

class _EnterHomeLatLngState extends State<EnterHomeLatLng> {
  bool showImage = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _authentication = FirebaseAuth.instance;
  double? max_lat;
  double? min_lat;
  double? max_long;
  double? min_long;

  @override
  void initState() {
    super.initState();
    // 5초 후에 이미지가 나타나도록 설정
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        showImage = true;
      });
    });
  }

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
        child: ListView(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Container(
                  padding: EdgeInsets.all(25),
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.width * 0.6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF6D71D2).withOpacity(0.3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 3,
                        spreadRadius: 3,
                        offset: const Offset(0, 1),
                      )
                    ],
                  ),
                  child: AnimatedOpacity(
                    duration: Duration(seconds: 1), // 페이드인 지속 시간
                    opacity: showImage ? 1.0 : 0.0, // 이미지가 보이거나 숨겨짐
                    child: Image.asset(
                      'assets/images/earth.png',
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.11,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'Enter the lantitude and longitude of your home',
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontFamily: 'silkscreen',
                            ),
                            speed: const Duration(milliseconds: 60),
                          ),
                        ],
                        totalRepeatCount: 1,
                      ),
                    )
                  ],
                ),
                Container(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: TextFormField(
                                style: TextStyle(
                                    color: Colors.white), // 입력 텍스트 색상을 하얀색으로 설정
                                decoration: InputDecoration(
                                  hintText: "max lat",
                                  hintStyle: TextStyle(
                                    color: Colors.white, // 힌트 텍스트 색상 변경
                                    fontFamily: "silkscreen",
                                    fontSize: 16.0, // 힌트 텍스트 글꼴 크기 변경
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white, // 밑줄 색상
                                      width: 1.0, // 밑줄 두께
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white, // 포커스된 밑줄 색상
                                      width: 1.0, // 포커스된 밑줄 두께
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.only(left: 10),
                                ),
                                onChanged: (value) {
                                  max_lat = double.parse(value);
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter max lat';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: TextFormField(
                                style: TextStyle(
                                    color: Colors.white), // 입력 텍스트 색상을 하얀색으로 설정
                                decoration: InputDecoration(
                                  hintText: "min lat",
                                  hintStyle: TextStyle(
                                    color: Colors.white, // 힌트 텍스트 색상 변경
                                    fontFamily: "silkscreen",
                                    fontSize: 16.0, // 힌트 텍스트 글꼴 크기 변경
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white, // 밑줄 색상
                                      width: 1.0, // 밑줄 두께
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white, // 포커스된 밑줄 색상
                                      width: 1.0, // 포커스된 밑줄 두께
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.only(left: 10),
                                ),
                                onChanged: (value) {
                                  min_lat = double.parse(value);
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter min lat';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: TextFormField(
                                //controller: _maxLongController, // 컨트롤러 할당
                                style: TextStyle(
                                    color: Colors.white), // 입력 텍스트 색상을 하얀색으로 설정
                                decoration: InputDecoration(
                                  hintText: "max long",
                                  hintStyle: TextStyle(
                                    color: Colors.white, // 힌트 텍스트 색상 변경
                                    fontFamily: "silkscreen",
                                    fontSize: 16.0, // 힌트 텍스트 글꼴 크기 변경
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white, // 밑줄 색상
                                      width: 1.0, // 밑줄 두께
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white, // 포커스된 밑줄 색상
                                      width: 1.0, // 포커스된 밑줄 두께
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.only(left: 10),
                                ),
                                onChanged: (value) {
                                  max_long = double.parse(value);
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter max long';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: TextFormField(
                                //controller: _minLongController, // 컨트롤러 할당
                                style: TextStyle(
                                    color: Colors.white), // 입력 텍스트 색상을 하얀색으로 설정
                                decoration: InputDecoration(
                                  hintText: "min long",
                                  hintStyle: TextStyle(
                                    color: Colors.white, // 힌트 텍스트 색상 변경
                                    fontFamily: "silkscreen",
                                    fontSize: 16.0, // 힌트 텍스트 글꼴 크기 변경
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white, // 밑줄 색상
                                      width: 1.0, // 밑줄 두께
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white, // 포커스된 밑줄 색상
                                      width: 1.0, // 포커스된 밑줄 두께
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.only(left: 10),
                                ),
                                onChanged: (value) {
                                  min_long = double.parse(value);
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter min long';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(105, 50),
                    primary: Color(0xFF6D71D2).withOpacity(0.4),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45), // 모서리를 둥글게
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final newUser = await _authentication.currentUser;
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(newUser!.uid)
                          .update({
                        'max_lat': max_lat,
                        'min_lat': min_lat,
                        'max_long': max_long,
                        'min_long': min_long
                      });
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => LoadingWithNextPage(
                            nextPage: HomePage(),
                            duration: 2,
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Enter',
                    style: TextStyle(
                        height: 1.3,
                        color: Colors.white,
                        fontSize: 22,
                        fontFamily: 'silkscreen'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
