import 'dart:async';
import 'dart:convert';

import 'package:bestpractice/core/network/cache_request_handler.dart';
import 'package:bestpractice/core/model/request_data.dart';
import 'package:bestpractice/core/model/failure.dart';
import 'package:bestpractice/core/utils/constants.dart';
import 'package:bestpractice/core/utils/log.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

enum Method {
  GET,
  POST,
  PUT,
}

class Network extends GetConnect {
  late CacheRequestHandler cacheRequestHandler;

  @override
  void onInit() {
    httpClient.baseUrl = Constants.BASE_URL;
    cacheRequestHandler = CacheRequestHandler();
    httpClient.defaultContentType = 'application/json; charset=utf-8';
    super.onInit();
  }

  Stream createConnection<T>(
    String path,
    Method method,
    Function(dynamic)? f, {
    bool resendRequest = false,
    bool cacheRequest = false,
    Map<String, String> headers = const {},
    Map<String, dynamic> body = const {},
    Map<String, dynamic> queryParams = const {},
  }) {
    StreamController streamController = StreamController.broadcast();
    Stream stream = streamController.stream;

    switch (method) {
      case Method.GET:
        get(
          path,
          headers: headers,
          query: queryParams,
        ).asStream().listen((response) async {
          RequestData requestData = RequestData(
              this,
              response,
              path,
              method,
              f,
              resendRequest,
              cacheRequest,
              streamController,
              body,
              headers,
              queryParams,
              DateTime.now());

          var result = await requestHandler<T>(requestData);
          streamController.add(result);

          // REQUEST SUCCESSFULL OR FAILURE & DONT RESEND REQUEST = CLOSE STREAM
          if (result.isRight() || result.isLeft() && !resendRequest) {
            streamController.close();
          }
        });
        break;
      case Method.POST:
      this.baseUrl = 'http://10.0.2.2:5000';
        post(path, body).asStream().listen((response) async {
          RequestData requestData = RequestData(
              this,
              response,
              path,
              method,
              f,
              resendRequest,
              cacheRequest,
              streamController,
              body,
              headers,
              queryParams,
              DateTime.now());

          
          var result = await requestHandler<T>(requestData);
          streamController.add(result);
        });
        break;
      case Method.PUT:
        break;
      default:
        break;
    }
    return stream;
  }

  Future<Either<Failure, dynamic>> requestHandler<T>(
      RequestData requestData) async {
    switch (requestData.response.isOk) {
      // OK RESPONSE
      case true:
        {
          var result;
          if (requestData.parser != null) {
            result = requestData.parser!.call(requestData.response.body);
          }
          else{
            result = requestData.response.body;
          }

          // LOG RESPONSE
          logResponse(
              1,
              "SUCCESS (${requestData.response.statusCode}): " +
                  requestData.method.toString(),
              requestData.path,
              Constants.BASE_URL + requestData.path,
              Constants.BASE_URL);

          // CACHE REQUEST IF WISHED
          if (requestData.cacheRequest) {
            cacheRequestHandler.addResponseToCache(requestData);
          }

          return Right<Failure, T>(result);
        }

      // ERROR RESPONSE
      case false:
        {
          // CACHED DATA FOUND -> GET CACHE DATA
          if (cacheRequestHandler.hasDataInCache(requestData) &&
              requestData.cacheRequest) {
            String cachedJson = cacheRequestHandler
                .getDataFromCache(requestData.method.toString().split(".").last,
                    requestData.path)
                ?.response;
            var cachedData;
            if(requestData.parser != null){
                cachedData = requestData.parser!.call(jsonDecode(cachedJson));
            }
            else{
               cachedData = cachedJson;
            }
          
            return Right<Failure, T>(cachedData);
          }
          // SHOULD RESEND REQUEST
          if (requestData.resendRequest) {
            resendRequest(requestData, requestData.resultController);
          }

          // LOG RESPONSE
          logResponse(
              0,
              "ERROR: (${requestData.response.statusCode}): " +
                  requestData.method.toString(),
              requestData.path,
              Constants.BASE_URL + requestData.path,
              Constants.BASE_URL,
              statusText: requestData.response.statusText!,
              noInternet: " 🚫 - CHECK INTERNET CONNECTION ");

          return Left<Failure, T>(Failure(requestData.response.statusText,
              requestData.response.statusCode));
        }
      default:
        return Left<Failure, T>(Failure(
            requestData.response.statusText, requestData.response.statusCode));
    }
  }

  void resendRequest<T>(RequestData cachedRequest, StreamController result) {
    Timer.periodic(Duration(seconds: 5), (Timer t) {
      createConnection(
        cachedRequest.path,
        cachedRequest.method,
        cachedRequest.parser,
        resendRequest: cachedRequest.resendRequest,
        cacheRequest: cachedRequest.cacheRequest,
        body: cachedRequest.body,
        headers: cachedRequest.headers,
        queryParams: cachedRequest.queryParams,
      ).listen((event) {
        event.fold((a) {}, (b) {
          result.add(Right<Failure, dynamic>(b));
        });
        t.cancel();
      });
    });
  }

  void logResponse(
      int type, String statusCode, String method, String path, String fullPath,
      {String statusText = "", String noInternet = ""}) {
    switch (type) {
      case 0:
        {
          Log().e(statusCode + method + " | " + path + " | " + fullPath,
              " | " + statusText + " | " + noInternet);
          break;
        }
      case 1:
        {
          Log().d(
            statusCode + method + " | " + path + " | " + fullPath,
          );
        }
    }
  }
}
