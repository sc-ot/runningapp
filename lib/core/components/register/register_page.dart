import 'package:bestpractice/core/components/register/register_controller.dart';
import 'package:bestpractice/core/utils/uihandler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller.dart';

class RegisterPage extends StatelessWidget implements UIHandler {
  RegisterPage({Key? key}) : super(key: key);

  final registerController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<RegisterController>(
        init: registerController,
        builder: (registerController) {
          return handleUi();
        },
      ),
    );
  }

  @override
  Widget errorStateUi() {
    return Text("ERROR!");
  }

  @override
  Widget idleStateUi() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: PageView(
            children: [
              Center(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Benutzername",
                    hintStyle: TextStyle(
                      fontSize: 30,
                      
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: Icon(
                Icons.next_week,
              ),
              onPressed: () {},
              iconSize: 30,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget internetConnectivityStateUi() {
    return idleStateUi();
  }

  @override
  Widget loadingStateUi() {
    return CircularProgressIndicator();
  }

  @override
  Widget noInternetConnectivityStateUi() {
    return idleStateUi();
  }

  @override
  Widget successStateUi() {
    return idleStateUi();
  }

  @override
  Widget handleUi() {
    switch (registerController.state.runtimeType) {
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
