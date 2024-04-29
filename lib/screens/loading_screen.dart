import 'dart:async';

import 'package:flutter/material.dart';

class LoadingWithNextPage extends StatefulWidget {
  final Widget nextPage;
  final int duration;
  const LoadingWithNextPage({
    Key? key,
    required this.nextPage,
    required this.duration,
  }) : super(key: key);

  @override
  _LoadingWithNextPageState createState() => _LoadingWithNextPageState();
}

class _LoadingWithNextPageState extends State<LoadingWithNextPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration), // 애니메이션 지속 시간 설정
    )..repeat(reverse: true); // 애니메이션을 반복하여 이동하도록 설정

    _offsetAnimation = Tween<Offset>(
      begin: Offset(-0.2, 0),
      end: Offset(0.3, 0), // 이미지가 오른쪽으로 이동하도록 설정
    ).animate(_controller);

    // 3초 후에 다른 페이지로 이동
    Timer(Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => widget.nextPage),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6D71D2), Color(0xFF202475)],
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 300,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SlideTransition(
                  position: _offsetAnimation,
                  child: Image(
                    image: AssetImage(
                      'assets/images/loading_image.png',
                      // adjust the width and alignment as needed
                    ),
                    height: 150,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            LinearProgressIndicator(
              minHeight: 3,
              backgroundColor: Colors.white.withOpacity(0.5),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class Loading extends StatefulWidget {
  const Loading({
    Key? key,
  }) : super(key: key);

  @override
  _LoadingWithNextPageState createState() => _LoadingWithNextPageState();
}

class _LoadingState extends State<LoadingWithNextPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10), // 애니메이션 지속 시간 설정
    )..repeat(reverse: true); // 애니메이션을 반복하여 이동하도록 설정

    _offsetAnimation = Tween<Offset>(
      begin: Offset(-0.2, 0),
      end: Offset(0.3, 0), // 이미지가 오른쪽으로 이동하도록 설정
    ).animate(_controller);

    // 3초 후에 다른 페이지로 이동
    Timer(Duration(seconds: 3), () {
      if (mounted) {
        // 예를 들어 다른 페이지로 이동하는 코드를 작성
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => widget.nextPage),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF858AFF), Color(0xFF9492FF), Color(0xFFBFA8FF)],
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 300,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SlideTransition(
                  position: _offsetAnimation,
                  child: Image(
                    image: AssetImage(
                      'assets/images/loading_dog.png',
                      // adjust the width and alignment as needed
                    ),
                    height: 150,
                  ),
                ),
              ],
            ),
            LinearProgressIndicator(
              minHeight: 3,
              backgroundColor: Colors.white.withOpacity(0.5),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
