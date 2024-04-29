import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FindDog extends StatefulWidget {
  final currentLat;
  final currentLong;
  const FindDog({
    super.key,
    required this.currentLat,
    required this.currentLong,
  });

  @override
  State<FindDog> createState() => _FindDogState();
}

class _FindDogState extends State<FindDog> {
  static final LatLng schoolLatlng = LatLng(
    //위도와 경도 값 지정
    37.5048940706581,
    126.95508069893845,
  );

  static final CameraPosition initialPosition = CameraPosition(
    //지도를 바라보는 카메라 위치
    target: schoolLatlng, //카메라 위치(위도, 경도)
    zoom: 15, //확대 정도
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // title: Text(
          //   'Here is you dog',
          //   style: TextStyle(color: Colors.black),
          // ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Stack(children: <Widget>[
          GoogleMap(
            //구글 맵 사용
            mapType: MapType.normal, //지도 유형 설정
            initialCameraPosition: initialPosition, //지도 초기 위치 설정
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 80,
              height: 80,
              child: Image.asset("assets/images/map_marker.png"),
            ),
          ),
        ]));
  }
}
