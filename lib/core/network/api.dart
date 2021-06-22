import 'dart:async';

import 'package:bestpractice/core/model/login_response.dart';
import 'package:bestpractice/core/network/network.dart';

class Api extends Network {
 

  Stream login(Map<String, String> body) => createConnection<LoginResponse>(
        "/api/v1/login",
        Method.POST,
        (a) => LoginResponse.fromJson(a),
        body: body,
        cacheRequest: false,
      );

   Stream registerUser(Map<String, String> body) => createConnection<Map<String,dynamic>>(
        "/api/v1/register",
        Method.POST,
        null,
        body: body,
        cacheRequest: false,

      );
}
