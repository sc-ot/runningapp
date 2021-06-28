import 'dart:async';
import 'dart:convert';

import 'package:bestpractice/controller.dart';
import 'package:bestpractice/core/components/home/home_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HistoryMapsController extends Controller {
  Completer<GoogleMapController> mapsControllerCompleter = Completer();
  late GoogleMapController mapsController;
  CameraPosition? cameraPosition;
  List<Position> positions = [];

  @override
  void onInit() {
    List<dynamic> encoded = jsonDecode(Get.arguments["positions"]);
    encoded.forEach((element) {
      positions.add(Position.fromMap(element));
    });

    initMaps();
    super.onInit();
  }

  void initLocation()  {
    cameraPosition = CameraPosition(
      zoom: CAMERA_ZOOM_FACTOR,
      target: LatLng(
        positions.first.latitude,
        positions.first.longitude,
      ),
    );
    mapsController.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition!),
    );
  }

  void initMaps() {
    mapsControllerCompleter.future.then(
      (value) async {
        mapsController = value;
        initLocation();
         setState(SUCCESS());
      },
    );
   
  }
}
