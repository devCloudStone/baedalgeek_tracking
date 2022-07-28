import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InItScreen extends StatelessWidget {
  const InItScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '배달긱',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const TextField(
                decoration: InputDecoration(
                  labelText: '휴대폰 번호',
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed('/tracking-location');
                },
                child: const Text('사용자 등록'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
