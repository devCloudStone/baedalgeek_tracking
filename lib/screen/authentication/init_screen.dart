import 'package:baedalgeek_driver/config/constants.dart';
import 'package:baedalgeek_driver/global/global.dart';
import 'package:baedalgeek_driver/widget/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class InItScreen extends StatelessWidget {
  InItScreen({Key? key}) : super(key: key);

  final _phoneNumberController = TextEditingController();

  Widget textFieldWidget() {
    return TextField(
      textAlignVertical: TextAlignVertical.center,
      autofocus: false,
      controller: _phoneNumberController,
      maxLength: 8,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: AppColors.fontColor),
      cursorColor: AppColors.fontColor,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp('[0-9]'),
        ),
      ],
      decoration: const InputDecoration(
        counterText: '',
        isDense: true,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: AppColors.inputUnFocusColor, width: 1.0),
        ),
        contentPadding: EdgeInsets.only(
          left: 10,
          right: 10,
          top: 15,
          bottom: 15,
        ),
        labelText: '휴대폰 번호',
        labelStyle: TextStyle(
          fontSize: AppFontSize.mediumTitleFontSize,
          color: AppColors.subTextColor,
        ),
        prefixText: '010',
      ),
    );
  }

  bool checkValidPhoneNumber() {
    FocusManager.instance.primaryFocus?.unfocus();
    final phoneNumberLength = _phoneNumberController.value.text.length;
    if (phoneNumberLength == 8) {
      return true;
    }
    warnValidDialog('', '휴대폰 번호를 확인 바랍니다');
    return false;
  }

  void saveUserInfo() {
    final phoneNumber = '010${_phoneNumberController.value.text}';
    sharedPreferences!.setString('phoneNumber', phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(
            '배달긱',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                textFieldWidget(),
                const SizedBox(
                  height: 100,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      if (checkValidPhoneNumber()) {
                        saveUserInfo();
                        _phoneNumberController.clear();
                        Get.offAllNamed('/tracking-location');
                      }
                    },
                    child: const Text('사용자 등록'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
