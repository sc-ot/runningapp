import 'package:bestpractice/core/components/register/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPageGenderWidget extends StatelessWidget {
   RegisterPageGenderWidget({Key? key}) : super(key: key);

  RegisterController registerController = Get.find<RegisterController>();

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RadioListTile<Gender>(
            title: const Text('männlich'),
            value: Gender.male,
            groupValue: registerController.gender,
            onChanged: (Gender? value) {
              registerController.changeGender(value);
            },
          ),
          RadioListTile<Gender>(
            title: const Text('weiblich'),
            value: Gender.female,
            groupValue:  registerController.gender,
            onChanged: (Gender? value) {
               registerController.changeGender(value);
            },
          ),
        ],
      ),
    );
  }
}
