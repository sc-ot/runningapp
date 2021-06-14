import 'dart:async';

import 'package:bestpractice/controller.dart';
import 'package:bestpractice/core/model/post.dart';
import 'package:bestpractice/core/model/postlist.dart';
import 'package:bestpractice/core/network/api.dart';
import 'package:bestpractice/core/services/location_service.dart';
import 'package:bestpractice/core/services/weather_service.dart';
import 'package:bestpractice/core/utils/state.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:weather/weather.dart';

import '../../model/post.dart';

class POSITION_CHANGE extends UIState {}

class HomeController extends Controller {
  Api postApi = Get.find();
  late PostList? posts;
  late List<Post> posts2;
  late CameraPosition cameraPosition;
  late bool activeRun;
  Completer<GoogleMapController> mapsControllerCompleter = Completer();
  late GoogleMapController mapsController;
  late Timer currentTime;
  late String titleCurrentTime;
  double speed = 0;
  int minute = 0;
  int hour = 0;
  int second = 0;
  late Marker marker;
  List<LatLng> positions = [];
  String city = "";
  double weatherTemperature = 0;

  @override
  void onInit() {
    activeRun = false;
    titleCurrentTime = "00:00:00";
    initLocation();
    super.onInit();
    setState(LOADING());
  }

  void startOrStopRun() => activeRun ? stopRun() : startRun();

  void initLocation() async {
    LocationData? locationData = await LocationService.getLocation();
    if (locationData != null) {
      cameraPosition = CameraPosition(
        zoom: 15,
        target: LatLng(
          locationData.latitude!,
          locationData.longitude!,
        ),
      );
      LocationService.location.onLocationChanged.listen(
        (position) {
          speed = position.speed ?? 0;
          print(speed);
          positions.add(
            LatLng(
              position.latitude!,
              position.longitude!,
            ),
          );
          cameraPosition = CameraPosition(
            zoom: 15,
            target: LatLng(
              position.latitude!,
              position.longitude!,
            ),
          );
          marker = Marker(
            markerId: MarkerId("1"),
            position: LatLng(
              position.latitude!,
              position.longitude!,
            ),
          );
          getAdress();
        },
      );
    }
    mapsControllerCompleter.future.then((value) {
      mapsController = value;
      value.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition),
      );
      marker = Marker(
        markerId: MarkerId("1"),
        position: cameraPosition.target,
      );
    });
    getAdress();
    setState(SUCCESS());
  }

  void getAdress() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      cameraPosition.target.latitude,
      cameraPosition.target.longitude,
    );
    city = placemarks.first.locality ?? "Nicht gefunden";
    setState(POSITION_CHANGE());
  }

  void getWeather() async {
    Weather? weather = await WeatherService.getWeather(
        cameraPosition.target.latitude, cameraPosition.target.longitude);
    weatherTemperature = weather?.temperature?.celsius ?? 0;
    setState(SUCCESS());
  }

  void centerCamera() {
    mapsController.animateCamera(
      CameraUpdate.newCameraPosition(
        cameraPosition,
      ),
    );
  }

  void startRun() {
    currentTime = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        updateTime();
      },
    );
    activeRun = true;
  }

  void stopRun() {
    second = 0;
    minute = 0;
    hour = 0;
    currentTime.cancel();
    activeRun = false;
  }

  void pauseRun() {
    currentTime.cancel();
    activeRun = false;
  }

  void updateTime() {
    second++;
    if (second == 60) {
      minute++;
      second = 0;
    }
    if (minute == 60) {
      minute = 0;
      hour++;
    }

    titleCurrentTime = addLeadingZeroNumber(hour) +
        ":" +
        addLeadingZeroNumber(minute) +
        ":" +
        addLeadingZeroNumber(second);
    setState(SUCCESS());
  }

  String addLeadingZeroNumber(int number) {
    return number < 10 ? "0" + number.toString() : number.toString();
  }

  /* void getPostData() {
    setState(STATE.LOADING);
    postApi.getPostData().listen(
      (response) {
        response.fold(
          (Failure failure) {
            setState(STATE.ERROR);
          },
          (dynamic data) {
            posts2.add(data);
            setState(STATE.LOADED);
          },
        );
      },
    );
  }*/
}
