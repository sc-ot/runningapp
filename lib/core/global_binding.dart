import 'package:bestpractice/core/network/api.dart';
import 'package:get/get.dart';

class GlobalBinding implements Bindings {
  @override
  void dependencies() async {
    Get.put(Api());
  }
}
