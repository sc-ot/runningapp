import 'package:bestpractice/controller.dart';
import 'package:flutter/material.dart';

abstract class UIHandler {
  Widget idleStateUi();
  Widget loadingStateUi();
  Widget successStateUi();
  Widget errorStateUi();
  Widget internetConnectivityStateUi();
  Widget noInternetConnectivityStateUi();
  Widget handleUi({
    required Widget idle,
    required Widget loading,
    required Widget success,
    required Widget error,
    required Widget internetConnectivity,
    required Widget noInternetConnectivity,
  });

}

