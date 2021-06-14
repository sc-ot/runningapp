import 'package:bestpractice/core/components/login/register_page.dart';
import 'package:bestpractice/core/global_binding.dart';
import 'package:bestpractice/core/components/login/login_page.dart';
import 'package:bestpractice/core/middleware/auth_middleware.dart';
import 'package:bestpractice/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:isolate_handler/isolate_handler.dart';

import 'core/components/home/home_page.dart';
import 'core/db/storage.dart';
import 'core/model/cache_data.dart';
import 'core/network/cache_request_handler.dart';
import 'core/utils/routes.dart';

void cacheSetup(Map<String, dynamic> context) {
  final messenger = HandledIsolate.initialize(context);

  messenger.listen(
    (start) async {
      CacheRequestHandler cacheRequestHandler = CacheRequestHandler();
      await initCache(cacheRequestHandler);
      await cacheRequestHandler.startRequests();
    },
  );
}

Future<void> initCache(CacheRequestHandler cacheRequestHandler) async {
  await Hive.initFlutter();
  Hive.registerAdapter(CacheDataAdapter());
  await cacheRequestHandler.initCache();
}

final isolates = IsolateHandler();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CacheRequestHandler cacheRequestHandler = CacheRequestHandler();
  await initCache(cacheRequestHandler);
  Constants.loggedIn = await Storage.load("loggedIn");

  runApp(GetMaterialApp(
    enableLog: false,
    initialBinding: GlobalBinding(),
    initialRoute: Routes.INIT,
    getPages: [
      GetPage(
        name: Routes.INIT,
        page: () => StartUp(),
        middlewares: [AuthMiddleware()],
      ),
      GetPage(
        name: Routes.HOME,
        page: () => HomePage(),
        middlewares: [AuthMiddleware()],
      ),
      GetPage(
        name: Routes.LOGIN,
        page: () => LoginPage(),
        middlewares: [],
      ),
      GetPage(
        name: Routes.REGISTER,
        page: () => RegisterPage(),
        middlewares: [],
      ),
    ],
  ));
}

class StartUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}
