import 'package:bestpractice/core/components/register/register_controller.dart';
import 'package:bestpractice/core/components/register/register_page_gender_widget.dart';
import 'package:bestpractice/core/components/register/register_page_height_widget.dart';
import 'package:bestpractice/core/components/register/register_page_name_widget.dart';
import 'package:bestpractice/core/components/register/register_page_overview_widget.dart';
import 'package:bestpractice/core/components/register/register_page_weight_widget.dart';
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
        PageView(
          controller: registerController.pageController,
          children: [
          
            Center(
              child: RegisterPageHeightWidget(),
            ),
           
            Center(
              child: RegisterPageWeightWidget(),
            ),
            Center(
              child: RegisterPageOverviewWidget(),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton.extended(
              backgroundColor: Get.theme.backgroundColor,
              onPressed: () {
                registerController.nextPage();
              },
              
              icon:  Icon(Icons.navigate_next_rounded),
              label: Text("Weiter"),
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
