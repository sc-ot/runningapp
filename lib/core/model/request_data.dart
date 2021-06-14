import 'dart:async';

import 'package:bestpractice/core/network/network.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class RequestData {
  Network network;
  Response<dynamic> response;
  String path;
  Method method;
  Function(dynamic)? parser;
  bool resendRequest;
  bool cacheRequest;
  Map<String, dynamic> body;
  Map<String, String> headers;
  Map<String, dynamic> queryParams;
  StreamController resultController;
  DateTime timeStamp;

  RequestData(
      this.network,
      this.response,
      this.path,
      this.method,
      this.parser,
      this.resendRequest,
      this.cacheRequest,
      this.resultController,
      this.body,
      this.headers,
      this.queryParams,
      this.timeStamp);
}
