import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'enter_lat_lng_screen.dart';

class EnterDogName extends StatefulWidget {
  const EnterDogName({Key? key});

  @override
  State<EnterDogName> createState() => _EnterDogNameState();
}

class _EnterDogNameState extends State<EnterDogName> {
  Future setLogin() async {
    // 로그인 상태를 저장
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogin', true);
  }

  bool showImage = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nicknameController = TextEditingController();
  final _authentication = FirebaseAuth.instance;
  String? dog_name;

  @override
  void initState() {
    super.initState();
    // 5초 후에 이미지가 나타나도록 설정
    Future.delayed(Duration(seconds: 4), () {
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
                      'assets/images/dog_astronaut_sitting.png',
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'Nice to meet you :)',
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontFamily: 'silkscreen',
                            ),
                            speed: const Duration(milliseconds: 60),
                          ),
                          TypewriterAnimatedText(
                            'What is your dog\'s name?',
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
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _nicknameController, // 컨트롤러 할당
                      style:
                          TextStyle(color: Colors.white), // 입력 텍스트 색상을 하얀색으로 설정
                      decoration: InputDecoration(
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
                        dog_name = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your dog\'s name';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
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
                        'dog_name': dog_name,
                      });

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EnterHomeLatLng(),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'ENTER',
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
