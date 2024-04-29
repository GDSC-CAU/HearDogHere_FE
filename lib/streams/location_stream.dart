import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

const _API_PREFIX = 'http://34.64.105.217:8080';

class LocationStream {
  final Dio _dio = Dio();

  final _locationStreamController = StreamController<dynamic>.broadcast();

  Stream<dynamic> getCurrentLocation() {
    fetchLocation();
    return _locationStreamController.stream;
  }

  fetchLocation() async {
    try {
      final auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      String? uid = user?.uid;

      final response = await _dio.get("$_API_PREFIX/locates/$uid");
      //print(response.data);

      _locationStreamController.add(response.data);
    } catch (error) {
      // 에러 발생 시 스트림으로 에러 추가
      _locationStreamController.addError(error);
    }
  }

  // 스트림 컨트롤러 종료
  dispose() {
    _locationStreamController.close();
  }
}

LocationStream locationStream = LocationStream();
