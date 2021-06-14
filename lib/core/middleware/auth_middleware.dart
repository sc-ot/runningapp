import 'package:bestpractice/core/db/storage.dart';
import 'package:bestpractice/core/utils/constants.dart';
import 'package:bestpractice/core/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  bool? loggedIn = false;

  AuthMiddleware() {
    checkAuth();
  }

  void checkAuth() async {
    loggedIn = await Storage.load("loggedIn");
    if (loggedIn == null) {
      loggedIn = false;
    }
   
  }

  @override
  int? get priority => 0;
  @override
  RouteSettings? redirect(String? route) {
    // TRUE: ZUR LOGINPAGE

    if ( Constants.loggedIn == null || Constants.loggedIn == false){
      return RouteSettings(name: Routes.LOGIN);
    }
  }

  @override
  GetPage? onPageCalled(GetPage? page) {
    return super.onPageCalled(page);
  }

  @override
  Widget onPageBuilt(Widget page) {
    return super.onPageBuilt(page);
  }
}
