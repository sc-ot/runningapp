import 'dart:async';

import 'package:bestpractice/controller.dart';
import 'package:bestpractice/core/db/storage.dart';
import 'package:bestpractice/core/model/run.dart';
import 'package:bestpractice/core/network/api.dart';
import 'package:bestpractice/core/services/weather_service.dart';
import 'package:bestpractice/core/utils/constants.dart';
import 'package:bestpractice/core/utils/state.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather/weather.dart';
import 'package:geolocator/geolocator.dart';

class POSITION_CHANGE extends UIState {}

class HomeController extends Controller {
  Api postApi = Get.find();
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
  List<Position> positions = [];
  String city = "";
  double weatherTemperature = 0;

  late StreamSubscription<Position> positionStream;

  @override
  void onInit() {
    activeRun = false;
    titleCurrentTime = "00:00:00";
    initLocation();
    setState(LOADING());
    super.onInit();
  }

  void startOrStopRun() => activeRun ? stopRun() : startRun();

  void initLocation() async {
    Position? locationData = await Geolocator.getCurrentPosition();
    if (locationData != null) {
      cameraPosition = CameraPosition(
        zoom: 15,
        target: LatLng(
          locationData.latitude,
          locationData.longitude,
        ),
      );
    } else {
      cameraPosition = CameraPosition(
        zoom: 15,
        target: LatLng(
          50,
          50,
        ),
      );
    }


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
      },
    );
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

  void startPositionStream() {
    positionStream =
        Geolocator.getPositionStream(intervalDuration: Duration(seconds: 5))
            .listen(
      (Position position) {
        speed = position.speed;
        print(speed);
        positions.add(position);
        cameraPosition = CameraPosition(
          zoom: 15,
          target: LatLng(
            position.latitude,
            position.longitude,
          ),
        );
        marker = Marker(
          markerId: MarkerId("1"),
          position: LatLng(
            position.latitude,
            position.longitude,
          ),
        );
      },
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

    startPositionStream();
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
        minute, second);

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
}
