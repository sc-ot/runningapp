import 'dart:async';

import 'package:bestpractice/core/utils/log.dart';
import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';

import 'core/utils/state.dart';

typedef Stream ApiCall(int x);

class IDLE extends UIState {}

class LOADING extends UIState {}

class SUCCESS extends UIState {}

class ERROR extends UIState {}

class INTERNET_CONNECTIVITY extends UIState {}

class NO_INTERNET_CONNECTIVITY extends UIState {}

class Controller extends GetxController {
  late UIState _currentState;
  late StreamSubscription connectivityChangedSubscription;
  late bool dataLoaded;
  late bool firstStartup;
  UIState get state => _currentState;
  late Map<String, StreamSubscription> subscriptions;



  @override
  void onInit() {
    _currentState = IDLE();
    setState(IDLE());
    dataLoaded = false;
    firstStartup = true;
    connectivityChangedSubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      connectivityChanged(result);
    });
    super.onInit();
  }

  void changeState(UIState state) {
    this._currentState = state;
  }

  void connectivityChanged(ConnectivityResult result) {
    if (!firstStartup) {
      switch (result) {
        case ConnectivityResult.wifi:
          Log().i("WIFI DETECTED");
          setState(INTERNET_CONNECTIVITY());
          break;
        case ConnectivityResult.mobile:
          Log().i("MOBILE DETECTED");
          setState(INTERNET_CONNECTIVITY());
          break;
        case ConnectivityResult.none:
          Log().i("NO INTERNET DETECTED");
          setState(NO_INTERNET_CONNECTIVITY());
          break;
      }
    } else {
      firstStartup = !firstStartup;
    }
  }

  @override
  void onClose() {
    connectivityChangedSubscription.cancel();
    super.onClose();
  }

  void setState(UIState state) {
    Log().i("CURRENT STATE: " + state.toString());
    switch (state.runtimeType) {
      case SUCCESS:
        dataLoaded = true;
        break;
      case INTERNET_CONNECTIVITY:
        this._currentState = SUCCESS();

        return;
      default:
        {
          this._currentState = state;
        }
    }
    this._currentState = state;
    update();
  }
}
