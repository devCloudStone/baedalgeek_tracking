import 'package:flutter/material.dart';
import 'package:get/get.dart';

void warnValidDialog(String title, String content) {
  Get.dialog(
    AlertDialog(
      title: Text(
        title,
      ),
      content: Text(
        content,
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('확인'),
        )
      ],
    ),
  );
}
