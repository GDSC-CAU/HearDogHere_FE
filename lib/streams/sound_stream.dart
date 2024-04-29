import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';

const _API_PREFIX = 'http://34.64.105.217:8080';

class SoundStream {
  final Dio _dio = Dio();

  final _soundStreamController = StreamController<dynamic>.broadcast();
  //Stream<dynamic> get soundStream => _soundStreamController.stream;

  Stream<dynamic> getCurrentSound() {
    fetchSound();
    return _soundStreamController.stream;
  }

  fetchSound() async {
    try {
      final auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      String? uid = user?.uid;

      final response = await _dio.get("$_API_PREFIX/soundLog/$uid");

      _soundStreamController.add(response.data);
    } catch (error) {
      // 에러 발생 시 스트림으로 에러 추가
      _soundStreamController.addError(error);
    }
  }

  // 스트림 컨트롤러 종료
  dispose() {
    _soundStreamController.close();
  }
}

SoundStream soundStream = SoundStream();
