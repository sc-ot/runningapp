import 'package:bestpractice/controller.dart';
import 'package:bestpractice/core/db/storage.dart';
import 'package:bestpractice/core/model/failure.dart';
import 'package:bestpractice/core/model/login_response.dart';
import 'package:bestpractice/core/network/api.dart';
import 'package:bestpractice/core/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends Controller {
  late TextEditingController username;
  late TextEditingController password;
  Api postApi = Get.find();

  @override
  void onInit() {
    username = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  void loginUser() async {
    /* if (username.text == "ozan" && password.text == "123") {
     await Storage.save("loggedIn", true);
     Constants.loggedIn = true;
      Get.offAndToNamed("/home");
    } else {
      Get.showSnackbar(GetBar(
        titleText: Text(
          "Nutzerdaten sind falsch",
          style: TextStyle(color: Colors.red),
        ),
        messageText: Text(
          "Bitte korrigieren Sie Ihre Daten",
          style: TextStyle(color: Colors.white),
        ),
      ));
    }
  */

    postApi.login({
      "username": username.text,
      "password": password.text,
    }).listen((response) {
      response.fold(
        (Failure failure) {
          Get.snackbar("FEHLER!", failure.statusCode.toString());
        },
        (LoginResponse data) {
          if (data.exists!) {
            Get.snackbar("EINGELOGGT", "BRO BIST EINGELOGGT!");
          } else {
            Get.snackbar("VERKACKT", "BRO BIST NICHT EINGELOGGT!");
          }
        },
      );
    });
  }
}
