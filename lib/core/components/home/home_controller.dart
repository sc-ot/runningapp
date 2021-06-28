import 'dart:async';
import 'dart:convert';

import 'package:bestpractice/controller.dart';
import 'package:bestpractice/core/db/storage.dart';
import 'package:bestpractice/core/model/run.dart';
import 'package:bestpractice/core/network/api.dart';
import 'package:bestpractice/core/services/maps_service.dart';
import 'package:bestpractice/core/services/weather_service.dart';
import 'package:bestpractice/core/utils/constants.dart';
import 'package:bestpractice/core/utils/state.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather/weather.dart';
import 'package:geolocator/geolocator.dart';

class POSITION_CHANGE extends UIState {}

const CAMERA_ZOOM_FACTOR = 15.0;

class HomeController extends Controller {
  Api postApi = Get.find();
  late CameraPosition cameraPosition;
  late bool activeRun;
  Completer<GoogleMapController> mapsControllerCompleter = Completer();

  late GoogleMapController mapsController;
  late Timer currentTime;
  late Marker marker;

  int minute = 0;
  int hour = 0;
  int second = 0;

  double speed = 0;
  String city = "";
  double weatherTemperature = 0;

  List<Position> positions = [];

  late StreamSubscription<Position> positionStream;

  @override
  void onInit() {
    activeRun = false;
    initLocation();
    initGoogleMaps();

    setState(LOADING());
    super.onInit();
  }

  String getCurrentTime() {
    String secondString =
        second < 9 ? "0" + second.toString() : second.toString();
    String minuteString =
        minute < 9 ? "0" + minute.toString() : minute.toString();
    String hourString = hour < 9 ? "0" + hour.toString() : hour.toString();

    return hourString + ":" + minuteString + ":" + secondString;
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
    setState(SUCCESS());
  }

  void startOrStopRun() => activeRun ? stopRun() : startRun();

  void initGoogleMaps() {
    mapsControllerCompleter.future.then(
      (value) {
        mapsController = value;
        value.animateCamera(
          CameraUpdate.newCameraPosition(cameraPosition),
        );
        marker = Marker(
          markerId: MarkerId("1"),
          position: cameraPosition.target,
        );
        getAdress();
        startPositionTracking(runStarted: false);
      },
    );
  }

  void initLocation() async {
    var position = await MapsService.getLocation();
    if (position == null) {
      cameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM_FACTOR,
        target: LatLng(
          50,
          50,
        ),
      );
    } else {
      cameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM_FACTOR,
        target: LatLng(
          position.latitude,
          position.longitude,
        ),
      );
    }
  }

  void getAdress() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      cameraPosition.target.latitude,
      cameraPosition.target.longitude,
    );
    city = placemarks.first.locality ?? "Nicht gefunden";
    setState(SUCCESS());
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

  void startPositionTracking({required bool runStarted}) {
    positionStream =
        Geolocator.getPositionStream(intervalDuration: Duration(seconds: 5))
            .listen(
      (Position position) {
        updateCamera(position);
        updateMarker(position);
        if (runStarted) {
          positions.add(position);
          speed = position.speed;
        }
        setState(SUCCESS());
      },
    );
  }

  void stopPositiongTracking() {
    positionStream.cancel();
  }

  void updateCamera(Position position) {
    cameraPosition = CameraPosition(
      zoom: 15,
      target: LatLng(
        position.latitude,
        position.longitude,
      ),
    );
    centerCamera();
  }

  void updateMarker(Position position) {
    marker = Marker(
      markerId: MarkerId("1"),
      position: LatLng(
        position.latitude,
        position.longitude,
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

    startPositionTracking(runStarted: true);
  }

  void stopRun() async {
    currentTime.cancel();
    activeRun = false;
    double avgSpeed = 0;
    double distance = 0;

    for (int i = 0; i < positions.length - 1; i++) {
      avgSpeed = avgSpeed + positions[i].speed;
      distance = distance +
          Geolocator.distanceBetween(
              positions[i].latitude,
              positions[i].longitude,
              positions[i + 1].latitude,
              positions[i + 1].longitude);
    }

    distance = distance / 1000;
    avgSpeed = avgSpeed / positions.length;

    double caloriesBurned = distance * 64 * 0.9;
    Run run = Run(distance, DateTime.now(), caloriesBurned, avgSpeed, hour,
        minute, second, jsonEncode(positions));

    Storage.load(Constants.HISTORY_RUN).then((historyRun) {
      List<Run> runs = [];
      if (historyRun != null) {
        runs = historyRun.cast<Run>().toList();
      }
      runs.add(run);
      Storage.save(Constants.HISTORY_RUN, runs);
      _resetData();
    });
  }

  void _resetData() {
    second = 0;
    minute = 0;
    hour = 0;
    positions.clear();
    positionStream.cancel();
    setState(SUCCESS());
  }

  String addLeadingZeroNumber(int number) {
    return number < 10 ? "0" + number.toString() : number.toString();
  }
}
