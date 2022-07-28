import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({Key? key}) : super(key: key);

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  bool checkProceeding = false;
  String buttonName = '업무 시작';

  bool checkTime() {
    final now = int.parse(DateFormat('HHmmss').format(DateTime.now()));
    if ((100000 < now && now < 140000) || (170000 < now && now < 200000)) {
      return true;
    }
    return false;
  }

  void repeatRequestFunction() {
    if (checkTime()) {
      const requestSec = Duration(seconds: 5);
      Timer.periodic(requestSec, (Timer t) => print('hi!'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('배달긱'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 300,
              child: ElevatedButton(
                onPressed: () {
                  if (checkTime()) {
                    repeatRequestFunction();
                    setState(() {
                      checkProceeding = !checkProceeding;
                      if (checkProceeding) {
                        buttonName = '지이잉 가동중...';
                      } else {
                        buttonName = '업무 시작';
                      }
                    });
                  }
                },
                child: Text(buttonName),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
