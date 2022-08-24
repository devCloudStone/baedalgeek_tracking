import 'dart:async';
import 'dart:convert';
import 'package:baedalgeek_driver/config/constants.dart';
import 'package:baedalgeek_driver/global/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({Key? key}) : super(key: key);

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  Map<String, String>? sendData;
  String? bodyData;
  Location location = Location();
  LocationData? _locationData;
  Timer? timer;
  bool checkProceeding = false;
  String workButtonName = '업무시작';
  final requestSec = 5;
  final phoneNumber = sharedPreferences!.getString('phoneNumber');

  bool checkTime() {
    final now = int.parse(DateFormat('HHmmss').format(DateTime.now()));
    // if ((103000 < now && now < 180000) || (190000 < now && now < 200000)) {
    //   return true;
    // }
    if (090000 < now && now < 220000) {
      return true;
    }
    return false;
  }

  _makeSendData() async {
    _locationData = await location.getLocation();
    sendData = {
      'latitude': _locationData!.latitude.toString(),
      'longitude': _locationData!.longitude.toString(),
      'phone': phoneNumber.toString()
    };
    bodyData = json.encode(sendData);
  }

  _sendTest() async {
    http.Response res = await http.post(
      Uri.parse('https://mq.baedalgeek.kr/api/v1/index/driver-tracking'),
      headers: {
        "Content-Type": "application/json",
        "auth":
            "c6079d737c94ddc0b37a2c3a93bfc7f7e371ef99391d7641d94beba757450f3d3d7d0b9dd171699bdc42d93518c31a97337495bcf7e6ab22a6a5203247ff111a"
      },
      body: bodyData,
    );
  }

  _sendingLocationToServer() async {
    if (checkTime()) {
      _proceedingAPI();
      _makeSendData();
      _sendTest();
      timer = Timer.periodic(Duration(seconds: requestSec), (timer) async {
        if (checkTime()) {
          _makeSendData();
          _sendTest();
        } else {
          _stopSendingLocationToServer();
        }
      });
    }
  }

  void _proceedingAPI() {
    checkProceeding = true;
    _changeButtonName('업무중');
  }

  void _stoppingAPI() {
    checkProceeding = false;
    _changeButtonName('업무시작');
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
                    phoneNumber!,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 20),
                  TextButton(
                    onPressed: () {
                      Get.offAllNamed('/');
                      removePhoneInfo();
                    },
                    child: const Text(
                      '번호변경',
                      style: TextStyle(
                        color: AppColors.fontColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Divider(color: AppColors.inputUnFocusColor, thickness: 1.0),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    onPrimary: AppColors.whiteColor,
                    primary: checkProceeding == false
                        ? AppColors.primaryColor
                        : AppColors.subTextColor,
                  ),
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
              const SizedBox(height: 10),
              !checkProceeding
                  ? const Center(
                      child: Text(
                        '업무시작시, 반드시 해당 버튼을 눌러주세요\n(이 때, 위치 액세스는 ‘항상 허용’ 으로 설정)',
                        style: TextStyle(
                          color: AppColors.subTextColor,
                          fontSize: 12,
                        ),
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
