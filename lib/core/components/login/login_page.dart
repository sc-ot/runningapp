import 'package:bestpractice/controller.dart';
import 'package:bestpractice/core/components/login/login_controller.dart';
import 'package:bestpractice/core/utils/constants.dart';
import 'package:bestpractice/core/utils/routes.dart';
import 'package:bestpractice/core/utils/uihandler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget implements UIHandler {
  LoginPage() : super();
  LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: loginController,
      builder: (homeController) {
        return Scaffold(
          body: SafeArea(
            child: handleUi(
              idle: idleStateUi(),
              loading: loadingStateUi(),
              success: successStateUi(),
              error: errorStateUi(),
              internetConnectivity: internetConnectivityStateUi(),
              noInternetConnectivity: noInternetConnectivityStateUi(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget errorStateUi() {
    return Text("FEHLER");
  }

  @override
  Widget idleStateUi() {
    return GetBuilder<LoginController>(
        init: loginController,
        builder: (_) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: Get.width * 0.5,
                  child: TextField(
                    controller: loginController.username,
                    decoration: InputDecoration(
                      hintText: "Username",
                    ),
                  ),
                ),
                Container(
                  width: Get.width * 0.5,
                  child: TextField(
                    controller: loginController.password,
                    decoration: InputDecoration(
                      hintText: "Passwort",
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        loginController.loginUser();
                      },
                      child: Text("Einloggen"),
                    ),
                     TextButton(
                  onPressed: () {
                    Get.toNamed(Routes.REGISTER);
                  },
                  child: Text("Registrieren"),
                ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget internetConnectivityStateUi() {
    return Text(" INTERNET");
  }

  @override
  Widget loadingStateUi() {
    return Text("LADEN");
  }

  @override
  Widget noInternetConnectivityStateUi() {
    return Text("KEIN INTERNET!");
  }

  @override
  Widget successStateUi() {
    return idleStateUi();
  }

  @override
  Widget handleUi(
      {required Widget idle,
      required Widget loading,
      required Widget success,
      required Widget error,
      required Widget internetConnectivity,
      required Widget noInternetConnectivity}) {
    switch (loginController.state.runtimeType) {
      case IDLE:
        return idle;
      case LOADING:
        return loading;
      case SUCCESS:
        return success;
      case ERROR:
        return error;
      case INTERNET_CONNECTIVITY:
        return internetConnectivity;
      case NO_INTERNET_CONNECTIVITY:
        return noInternetConnectivity;
      default:
        Container();
    }
    return Container();
  }
}
