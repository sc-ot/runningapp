import 'dart:convert';

import 'package:bestpractice/controller.dart';
import 'package:bestpractice/core/model/failure.dart';
import 'package:bestpractice/core/network/api.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

enum Gender { male, female }

class RegisterController extends Controller {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  PageController pageController = PageController();
  Gender? gender = Gender.male;
  int height = 180;
  int weight = 80;
  Api api = Get.find();

  @override
  void onInit() {
    setState(IDLE());
    super.onInit();
  }

  void nextPage(){
    pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  void changeHeight(int value){
    height = value;
    setState(IDLE());
  }

  void changeWeight(int value){
    weight = value;
    setState(IDLE());
  }
  void changeGender(Gender? value){
    gender = value;
    setState(IDLE());

  }
  void register() {
    String hashPassword = sha256.convert(utf8.encode(password.text)).toString();
    api.registerUser({
      "username": username.text,
      "password": hashPassword,
    }).listen(
      (response) {
        response.fold(
          (Failure f) {},
          (dynamic data) {
            if (!data["user_registered"]) {
              Get.showSnackbar(
                GetBar(
                  duration: Duration(seconds: 1),
                  title: "Fehlgeschlagen",
                  messageText: Text(data["error_message"]),
                ),
              );
            } else {
              Get.showSnackbar(
                GetBar(
                    duration: Duration(seconds: 1),
                    title: "Erfolgreich",
                    messageText: Text("Sie werden weitergeleitet")),
              );
            }
          },
        );
      },
    );
  }
}
