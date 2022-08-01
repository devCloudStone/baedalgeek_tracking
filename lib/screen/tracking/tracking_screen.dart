import 'dart:async';
import 'package:baedalgeek_driver/global/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({Key? key}) : super(key: key);

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  bool checkProceeding = false;
  String workButtonName = '업무 시작';
  final requestSec = 5;
  Timer? timer;
  final phoneNumber = sharedPreferences!.getString('phoneNumber');

  bool checkTime() {
    final now = int.parse(DateFormat('HHmmss').format(DateTime.now()));
    if ((103000 < now && now < 140000) || (170000 < now && now < 200000)) {
      return true;
    }
    return false;
  }

  void _sendingLocationToServer() {
    if (checkTime()) {
      _proceedingAPI();
      print('API 최초 호출');
      timer = Timer.periodic(Duration(seconds: requestSec), (timer) {
        if (checkTime()) {
          print('시간 통과 후 API 재호출 중'); // 메세지 큐 API 작
        } else {
          print('시간 통과 실패');
          _stopSendingLocationToServer();
        }
      });
    }
  }

  void _proceedingAPI() {
    checkProceeding = true;
    _changeButtonName('실행 중');
  }

  void _stoppingAPI() {
    print('api 멈춤');
    checkProceeding = false;
    _changeButtonName('업무 시작');
  }

  void _changeButtonName(String buttonName) {
    setState(() {
      workButtonName = buttonName;
    });
  }

  void _stopSendingLocationToServer() {
    _stoppingAPI();
    timer?.cancel();
  }

  void removePhoneInfo() {
    _stopSendingLocationToServer();
    sharedPreferences!.remove('phoneNumber');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('배달긱'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${phoneNumber!}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 20),
                  TextButton(
                    onPressed: () {
                      removePhoneInfo();
                      Get.offAllNamed('/');
                    },
                    child: const Text('변경 하기'),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                height: 300,
                child: ElevatedButton(
                  onPressed: () {
                    if (checkProceeding) {
                      _stopSendingLocationToServer();
                    } else {
                      _sendingLocationToServer();
                    }
                  },
                  child: Text(workButtonName),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
