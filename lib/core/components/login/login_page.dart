import 'dart:ui';

import 'package:bestpractice/controller.dart';
import 'package:bestpractice/core/components/login/login_controller.dart';
import 'package:bestpractice/core/utils/routes.dart';
import 'package:bestpractice/core/utils/uihandler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_animations/simple_animations.dart';

class LoginPage extends StatelessWidget implements UIHandler {
  LoginPage() : super();
  LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: loginController,
      builder: (homeController) {
        return Scaffold(
          body: handleUi(),
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
        return Stack(
          children: [
            Container(
              height: Get.height,
              child: Image.asset("assets/login_background.png",
                  fit: BoxFit.fitHeight),
            ),
            Center(
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(48.0),
                      child: Container(
                        child: Text(
                          "Runner",
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                              ),
                            ),
                            onPressed: () {},
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(48.0, 16, 48, 16),
                              child: Text(
                                "Loslegen",
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          child: Text(
                            "Noch nicht registriert? Registrieren",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Get.toNamed(Routes.REGISTER);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
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
  Widget handleUi() {
    switch (loginController.state.runtimeType) {
      case IDLE:
        return idleStateUi();
      case LOADING:
        return loadingStateUi();
      case SUCCESS:
        return successStateUi();
      case ERROR:
        return errorStateUi();
      case INTERNET_CONNECTIVITY:
        return internetConnectivityStateUi();
      case NO_INTERNET_CONNECTIVITY:
        return noInternetConnectivityStateUi();
      default:
        Container();
    }
    return Container();
  }
}
