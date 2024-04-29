import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:space_dog/streams/location_stream.dart';
import 'package:space_dog/streams/sound_stream.dart';
import 'dart:math' as math show sin, pi, sqrt;
import 'package:starsview/starsview.dart';

import 'package:space_dog/screens/find_dog_screen.dart';
import 'package:space_dog/firestore_manager.dart';
import 'package:space_dog/notification/local_notification.dart';
import 'package:space_dog/screens/notifications_screen.dart';
import 'settings_screen.dart';

class LocationProvider with ChangeNotifier {}

class SoundProvider with ChangeNotifier {}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  late Future<Map<String, dynamic>> myFuture;

  @override
  void initState() {
    //listenToNotifications();
    super.initState();
    myFuture = getUserData(db, auth);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color(0xFF6D71D2),
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'assets/images/title.png',
          width: MediaQuery.of(context).size.width * 0.5,
        ),
        actions: [
          IconButton(
              onPressed: () {
                // LocalNotifications.showSimpleNotification(
                //     title: "SpaceDog",
                //     body: "Your Dog has escaped",
                //     payload: "");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MySettings(),
                  ),
                );
              },
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ))
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF6D71D2),
                    Color(0xFF202475),
                  ],
                ),
              ),
            ),
            StarsView(
              fps: 60,
            ),
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: 0,
              child: Center(
                ///Here is our animation widget
                child: StreamBuilder(
                    stream: locationStream.getCurrentLocation(),
                    builder:
                        (BuildContext context, AsyncSnapshot locationSnapshot) {
                      return StreamBuilder(
                          stream: soundStream.getCurrentSound(),
                          builder: (BuildContext context,
                              AsyncSnapshot soundSnapshot) {
                            return FutureBuilder<Map<String, dynamic>>(
                              future: myFuture,
                              builder: (context, dogNameSnapshot) {
                                if (dogNameSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (dogNameSnapshot.hasError) {
                                  return Text(
                                      'Error: ${dogNameSnapshot.error}');
                                } else {
                                  if (dogNameSnapshot.hasData) {
                                    String dog_name =
                                        dogNameSnapshot.data!['dog_name'];
                                    // String currentSound =
                                    //     soundSnapshot.data!['sound'];
                                    // String currentLat =
                                    //     locationSnapshot.data!['latitude'];
                                    // String currentLong =
                                    //     locationSnapshot.data!['longitude'];
                                    return DogState(
                                        currentSound: 2,
                                        currentLat: 10.0,
                                        currentLong: 6.0,
                                        dogName: dog_name);
                                  } else {
                                    return Text('No data available');
                                  }
                                }
                              },
                            );
                          });
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DogState extends StatelessWidget {
  final int currentSound;
  final double currentLat;
  final double currentLong;
  final String dogName;

  const DogState(
      {Key? key,
      required this.currentSound,
      required this.currentLat,
      required this.currentLong,
      required this.dogName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // default state

    if (currentSound == 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FindDog(
                        currentLat: currentLat,
                        currentLong: currentLong,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 50, 0),
                  width: MediaQuery.of(context).size.width * 0.17,
                  height: MediaQuery.of(context).size.width * 0.17,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.withOpacity(0.7),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 3,
                        spreadRadius: 3,
                        offset: const Offset(0, 1),
                      )
                    ],
                  ),
                  child: Icon(
                    Icons.location_on,
                    color: Colors.white.withOpacity(0.8),
                    size: 40,
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.65,
            height: MediaQuery.of(context).size.width * 0.65,
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
            child: Stack(
              children: [
                WaveAnimation(
                  size: 170,
                  color: Colors.red,
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: Image.asset(
                    'assets/images/dog_state/escaped.png',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          MessageBox(
            message: '$dogName has escaped',
          ),
        ],
      );
    } else if (currentSound == 1) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FindDog(
                        currentLat: currentLat,
                        currentLong: currentLong,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 50, 0),
                  width: MediaQuery.of(context).size.width * 0.17,
                  height: MediaQuery.of(context).size.width * 0.17,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF6D71D2).withOpacity(0.8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 3,
                        spreadRadius: 3,
                        offset: const Offset(0, 1),
                      )
                    ],
                  ),
                  child: Icon(
                    Icons.location_on,
                    color: Colors.white.withOpacity(0.8),
                    size: 40,
                  ),
                ),
              ),
            ],
          ),
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.width * 0.7,
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
              ),
              Positioned(
                left: 0,
                top: 0,
                right: 0,
                bottom: 0,
                child: Image.asset(
                  'assets/images/dog_state/dog_floating.png',
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          MessageBox(
            message: '....',
          ),
        ],
      );
    }
    // when dog is barking
    else if (currentSound == 2) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FindDog(
                        currentLat: currentLat,
                        currentLong: currentLong,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 50, 0),
                  width: MediaQuery.of(context).size.width * 0.17,
                  height: MediaQuery.of(context).size.width * 0.17,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF6D71D2).withOpacity(0.8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 3,
                        spreadRadius: 3,
                        offset: const Offset(0, 1),
                      )
                    ],
                  ),
                  child: Icon(
                    Icons.location_on,
                    color: Colors.white.withOpacity(0.8),
                    size: 40,
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.65,
            height: MediaQuery.of(context).size.width * 0.65,
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
            child: Stack(
              children: [
                WaveAnimation(
                  size: 170,
                  color: Colors.white,
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: Image.asset(
                    'assets/images/dog_state/dog_bark.png',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          MessageBox(
            message: '$dogName is barking',
          ),
        ],
      );
    }
    // when dog broke something
    else if (currentSound == 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FindDog(
                        currentLat: currentLat,
                        currentLong: currentLong,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 50, 0),
                  width: MediaQuery.of(context).size.width * 0.17,
                  height: MediaQuery.of(context).size.width * 0.17,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF6D71D2).withOpacity(0.8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 3,
                        spreadRadius: 3,
                        offset: const Offset(0, 1),
                      )
                    ],
                  ),
                  child: Icon(
                    Icons.location_on,
                    color: Colors.white.withOpacity(0.8),
                    size: 40,
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.65,
            height: MediaQuery.of(context).size.width * 0.65,
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
            child: Stack(
              children: [
                WaveAnimation(
                  size: 170,
                  color: Colors.white,
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: Image.asset(
                    'assets/images/dog_state/fragile.png',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          MessageBox(
            message: 'Seems like $dogName broke something',
          ),
        ],
      );
    }
    // when dog escaped
    else {
      return SizedBox();
    }
  }
}

class MessageBox extends StatelessWidget {
  final String message;
  const MessageBox({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    // 현재 일시 가져오기
    DateTime now = DateTime.now();

    // 날짜와 시간을 문자열로 변환
    String currentDateTime =
        '${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}';

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(left: 13),
          width: MediaQuery.of(context).size.width * 0.87,
          height: MediaQuery.of(context).size.height * 0.11,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.black.withOpacity(0.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 3,
                spreadRadius: 3,
                offset: const Offset(0, 1),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$currentDateTime",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                  fontFamily: 'silkscreen',
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontFamily: 'silkscreen',
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 13, // 오른쪽 여백 설정
          top: 14, // 위쪽 여백 설정
          child: Container(
            width: 47,
            height: 47,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white.withOpacity(0.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 3,
                  spreadRadius: 3,
                  offset: const Offset(0, 1),
                )
              ],
              border: Border.all(
                // 테두리 추가
                color: Colors.white.withOpacity(0.5), // 테두리 색상 설정
                width: 2, // 테두리 두께 설정
              ),
            ),
            child: IconButton(
              icon: Icon(Icons.menu), // 아이콘 추가
              color: Colors.white.withOpacity(0.5), // 아이콘 색상 설정
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Notifications(),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class WaveAnimation extends StatefulWidget {
  final double size;
  final Color color;

  const WaveAnimation({
    this.size = 80.0,
    this.color = Colors.white,
    Key? key,
  }) : super(key: key);

  @override
  WaveAnimationState createState() => WaveAnimationState();
}

class WaveAnimationState extends State<WaveAnimation>
    with TickerProviderStateMixin {
  late AnimationController animCtr;

  @override
  void initState() {
    super.initState();
    animCtr = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
  }

  Widget getAnimatedWidget() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.size),
          gradient: RadialGradient(
            colors: [
              widget.color,
              Color.lerp(widget.color, Colors.black, .05)!
            ],
          ),
        ),
        child: ScaleTransition(
          scale: Tween(begin: 0.95, end: 1.0).animate(
            CurvedAnimation(
              parent: animCtr,
              curve: CurveWave(),
            ),
          ),
          child: Container(
            width: widget.size * 0.5,
            height: widget.size * 0.5,
            margin: const EdgeInsets.all(6),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(context) {
    return CustomPaint(
      painter: CirclePainter(animCtr, color: widget.color),
      child: SizedBox(
        width: widget.size * 1.6,
        height: widget.size * 1.6,
        child: getAnimatedWidget(),
      ),
    );
  }

  @override
  void dispose() {
    animCtr.dispose();
    super.dispose();
  }
}

class CirclePainter extends CustomPainter {
  final Color color;
  final Animation<double> animation;

  CirclePainter(
    this.animation, {
    required this.color,
  }) : super(repaint: animation);

  void circle(Canvas canvas, Rect rect, double value) {
    final double opacity = (0.9 - (value / 4.0)).clamp(0.0, 1.0);
    final Color rippleColor = color.withOpacity(opacity);
    final double size = rect.width / 2;
    final double area = size * size;
    final double radius = math.sqrt(area * value / 4);
    final Paint paint = Paint()..color = rippleColor;
    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    for (int wave = 3; wave >= 0; wave--) {
      circle(canvas, rect, wave + animation.value);
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) => true;
}

class CurveWave extends Curve {
  @override
  double transform(double t) {
    if (t == 0 || t == 1) {
      return 0.01;
    }
    return math.sin(t * math.pi);
  }
}
