import 'package:bestpractice/core/db/storage.dart';
import 'package:bestpractice/core/utils/constants.dart';
import 'package:bestpractice/core/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  AuthMiddleware() {
    print("TEST");
  }

  Future<bool> checkAuth() async {
    bool? authStatus = false;
    authStatus = await Storage.load("authStatus");
    if (authStatus == null) {
      authStatus = false;
    }
    return authStatus;
  }

  @override
  int? get priority => 0;
  @override
  RouteSettings? redirect(String? route) {
    // TRUE: ZUR LOGINPAGE
    print("REDIRECT");
    if(Constants.loggedIn == null || !Constants.loggedIn!){
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
