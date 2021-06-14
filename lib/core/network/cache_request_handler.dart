import 'dart:async';

import 'package:bestpractice/core/model/cache_data.dart';
import 'package:bestpractice/core/network/network.dart';
import 'package:bestpractice/core/model/request_data.dart';
import 'package:bestpractice/core/utils/constants.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../model/failure.dart';

class CacheRequestHandler extends GetConnect {
  late Map<String, Box> cache;
  late Network network;

  static final CacheRequestHandler _instance = CacheRequestHandler._internal();
  factory CacheRequestHandler() => _instance;

  CacheRequestHandler._internal() {
    network = Network();
    cache = {};
  }

  Future<void> initCache() async {
    cache["POST"] = await Hive.openBox("POST");
    cache["GET"] = await Hive.openBox("GET");
    cache["PUT"] = await Hive.openBox("PUT");
  }

  void addResponseToCache(RequestData requestData) {
    var currentCache = cache[requestData.method.toString().split(".").last];
    var timeStamp = currentCache?.get(requestData.path)?.timestamp;

    // ADD DATA TO CACHE IF ITS EMPTY OR THE LAST REasQUEST IS 24 HOURS AGO
    if (timeStamp == null ||
        DateTime.now().difference(timeStamp).inHours >
            Constants.CACHE_REQUEST_TIMER_HOURS) {
      CacheData cacheData = CacheData();
      cacheData.path = requestData.path;
      cacheData.queryParams = requestData.queryParams;
      cacheData.body = requestData.body;
      cacheData.headers = requestData.headers;
      cacheData.timestamp = requestData.timeStamp;
      cacheData.response = requestData.response.bodyString;
      currentCache?.put(requestData.path, cacheData);
    }
  }

  bool hasDataInCache(RequestData requestData) {
    var currentCache = requestData.method.toString().split(".").last;
    dynamic data = cache[currentCache]?.get(requestData.path);
    return data != null ? true : false;
  }

  dynamic getDataFromCache(String method, String path) {
    return  cache[method]?.get(path);
  }

  startRequests() async {
    return await Future.delayed(Duration(seconds: 3));
  }

  void resendRequest<T>(RequestData cachedRequest) {
    Timer.periodic(Duration(seconds: 5), (Timer t) {
      cachedRequest.network
          .createConnection(
        cachedRequest.path,
        cachedRequest.method,
        cachedRequest.parser,
        resendRequest: cachedRequest.resendRequest,
      )
          .listen((event) {
        event.fold((a) {}, (b) {
          cachedRequest.resultController.add(Right<Failure, dynamic>(b));
          t.cancel();
        });
      });
    });
  }
}
