import 'package:flutter/material.dart';

abstract class UIHandlerHome {
  Widget idleStateUi();
  Widget loadingStateUi();
  Widget successStateUi();
  Widget errorStateUi();
  Widget internetConnectivityStateUi();
  Widget noInternetConnectivityStateUi();
  Widget positionChangeStateUi();
  Widget handleUi({
    required Widget idle,
    required Widget loading,
    required Widget success,
    required Widget error,
    required Widget internetConnectivity,
    required Widget noInternetConnectivity,
    required Widget positionChange,
  });

}


