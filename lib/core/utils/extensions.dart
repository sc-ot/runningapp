import 'package:bestpractice/core/model/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_connect/http/src/response/response.dart';

extension EitherHandler on Either<Failure, Response<dynamic>> {
  bool get isFailure {
    return isLeft();
  }

  bool get isSuccess {
    return isRight();
  }
}

extension PositionMapHandler on Position {
  Position fromJson(Map<String, dynamic> json) {
    return Position(
      accuracy: json["accuracy"],
      altitude: json["altitude"],
      heading: json["heading"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      speed: json["speed"],
      speedAccuracy: json["speedAccuracy"],
      timestamp: json["timestamp"],
    );
  }
}
