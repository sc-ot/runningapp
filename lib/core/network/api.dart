import 'dart:async';

import 'package:bestpractice/core/model/login_response.dart';
import 'package:bestpractice/core/model/postlist.dart';
import 'package:bestpractice/core/network/network.dart';

import '../model/post.dart';
import 'cache_request_handler.dart';

class Api extends Network {
  Stream getPostListData() => createConnection<PostList>(
        "/posts",
        Method.GET,
        (a) => PostList.fromJson(a),
      );

  Stream getPostData() => createConnection<Post>(
        "/posts/1",
        Method.GET,
        (a) => Post.fromJson(a),
        cacheRequest: true,
      );

  Stream postPost(Map<String, String> body) => createConnection<Post>(
        "/posts/",
        Method.POST,
        (a) => Post.fromJson(a),
        body: body,
      );

  Stream login(Map<String, String> body) => createConnection<LoginResponse>(
        "/login",
        Method.POST,
        (a) => LoginResponse.fromJson(a),
        body: body,
        cacheRequest: false,
      );

   Stream registerUser(Map<String, String> body) => createConnection<Map<String,dynamic>>(
        "/register",
        Method.POST,
        null,
        body: body,
        cacheRequest: false,

      );
}
