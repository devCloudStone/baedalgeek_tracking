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
  String buttonName = '업무 시작';
  Timer? timer;
  final phoneNumber = sharedPreferences!.getString('phoneNumber');

  bool checkTime() {
    final now = int.parse(DateFormat('HHmmss').format(DateTime.now()));
    if ((103000 < now && now < 140000) || (170000 < now && now < 200000)) {
      return true;
    }
    return false;
  }

  void _sendingLocation() {
    const requestSec = Duration(seconds: 5);
    timer = Timer.periodic(requestSec, (timer) {
      print('hi');
    });
  }

  void _stopSendingLocation() {
    timer?.cancel();
  }

  void removePhoneInfo() {
    _stopSendingLocation();
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
                    '${phoneNumber!}님',
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
                    if (checkTime()) {
                      checkProceeding = !checkProceeding;
                      if (checkProceeding) {
                        buttonName = '지이잉 가동중...';
                        _sendingLocation();
                      } else {
                        buttonName = '업무 시작';
                        _stopSendingLocation();
                      }
                      setState(() {
                        buttonName;
                      });
                    }
                  },
                  child: Text(buttonName),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
