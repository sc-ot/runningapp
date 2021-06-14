import 'package:bestpractice/controller.dart';
import 'package:bestpractice/core/model/failure.dart';
import 'package:bestpractice/core/network/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RegisterController extends Controller {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  Api api = Get.find();

  @override
  void onInit() {
    setState(IDLE());
  }

  void register() {
    api.registerUser({
      "username": username.text,
      "password": password.text,
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
