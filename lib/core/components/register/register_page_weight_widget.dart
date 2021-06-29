import 'package:bestpractice/core/components/register/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';

class RegisterPageWeightWidget extends StatelessWidget {
  RegisterPageWeightWidget({Key? key}) : super(key: key);

  var registerController = Get.find<RegisterController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterController>(
      init: registerController,
      builder: (registerController) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NumberPicker(
              itemWidth: 140,
              decoration: BoxDecoration(
                  border: Border.symmetric(
                      horizontal:
                          BorderSide(width: 1, color: Get.theme.accentColor))),
              minValue: 30,
              maxValue: 220,
              haptics: true,
              textStyle: TextStyle(fontSize: 50, color: Get.theme.accentColor),
              selectedTextStyle: TextStyle(fontSize: 60, color: Colors.white),
              itemHeight: 100,
              value: registerController.weight,
              onChanged: (value) {
                registerController.changeWeight(value);
              },
            ),
            SizedBox(
              width: 32,
            ),
            Text(
              "kg",
              style: TextStyle(fontSize: 40, color: Get.theme.accentColor),
            ),
          ],
        );
      },
    );
  }
}
