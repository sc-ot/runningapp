import 'package:bestpractice/core/model/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get_connect/http/src/response/response.dart';

extension EitherHandler on Either<Failure, Response<dynamic>>{
 
  bool get isFailure {
    return isLeft();
  }
  bool get isSuccess{
    return isRight();
  }

}
