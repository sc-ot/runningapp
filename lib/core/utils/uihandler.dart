import 'package:flutter/material.dart';

abstract class UIHandler {
  Widget idleStateUi();
  Widget loadingStateUi();
  Widget successStateUi();
  Widget errorStateUi();
  Widget internetConnectivityStateUi();
  Widget noInternetConnectivityStateUi();
  Widget handleUi();

}


