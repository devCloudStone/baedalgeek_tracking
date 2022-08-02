import 'dart:async';
import 'package:baedalgeek_driver/global/global.dart';
import 'package:baedalgeek_driver/widget/alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({Key? key}) : super(key: key);

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  Location location = Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  Timer? timer;
  bool checkProceeding = false;
  String workButtonName = '업무 시작';
  String? testC;
  final requestSec = 5;
  final phoneNumber = sharedPreferences!.getString('phoneNumber');

  bool checkTime() {
    final now = int.parse(DateFormat('HHmmss').format(DateTime.now()));
    if ((103000 < now && now < 160000) || (170000 < now && now < 200000)) {
      return true;
    }
    return false;
  }

  Future<void> _sendingLocationToServer() async {
    if (checkTime()) {
      _proceedingAPI();
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled!) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled!) {
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }
      location.enableBackgroundMode(enable: true);
      _locationData = await location.getLocation();
      warnValidDialog('현재 위치',
          '위도: ${_locationData!.latitude} \n 경도: ${_locationData!.longitude}');

      print('API 최초 호출');
      timer = Timer.periodic(Duration(seconds: requestSec), (timer) async {
        if (checkTime()) {
          _locationData = await location.getLocation();
          setState(() {
            testC = _locationData!.latitude.toString();
          });
          warnValidDialog('현재 위치',
              '위도: ${_locationData!.latitude} \n 경도: ${_locationData!.longitude}');
          print('시간 통과 후 API 재호출 중'); // 메세지 큐 API 작업
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
              Text(testC.toString()),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    phoneNumber!,
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
