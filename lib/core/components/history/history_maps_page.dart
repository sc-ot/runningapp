import 'package:bestpractice/controller.dart';
import 'package:bestpractice/core/components/history/history_maps_controller.dart';
import 'package:bestpractice/core/utils/uihandler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HistoryMapsPage extends StatelessWidget implements UIHandler {
  HistoryMapsPage({Key? key}) : super(key: key);

  final historyMapscontroller = Get.put(HistoryMapsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder(
        init: historyMapscontroller,
        builder: (controller) {
          return handleUi();
        },
      ),
    );
  }

  @override
  Widget errorStateUi() {
    return Text("");
  }

  @override
  Widget handleUi() {
    switch (historyMapscontroller.state.runtimeType) {
      case IDLE:
        return idleStateUi();
      case LOADING:
        return loadingStateUi();
      case SUCCESS:
        return successStateUi();
      case ERROR:
        return errorStateUi();
      case INTERNET_CONNECTIVITY:
        return internetConnectivityStateUi();
      case NO_INTERNET_CONNECTIVITY:
        return noInternetConnectivityStateUi();
      default:
        Container();
    }
    return Container();
  }

  @override
  Widget idleStateUi() {
    return GoogleMap(
      mapType: MapType.terrain,
      polylines: {
        Polyline(
          polylineId: PolylineId("route"),
          color: Colors.red,
          width: 5,
        ),
      },
      initialCameraPosition: CameraPosition(target: LatLng(10, 20)),
      onMapCreated: (GoogleMapController controller) {
        historyMapscontroller.mapsControllerCompleter.complete(controller);
      },
    );
  }

  @override
  Widget internetConnectivityStateUi() {
    return Text("internet");
  }

  @override
  Widget loadingStateUi() {
    return Text("loading");
  }

  @override
  Widget noInternetConnectivityStateUi() {
    return Text("no internet");
  }

  @override
  Widget successStateUi() {
    return GoogleMap(
      initialCameraPosition: historyMapscontroller.cameraPosition!,
      mapType: MapType.terrain,
      polylines: {
        Polyline(
          polylineId: PolylineId("route"),
          color: Colors.red,
          width: 5,
          points: historyMapscontroller.positions
              .map((position) => LatLng(position.latitude, position.longitude))
              .toList(),
        ),
      },
      onMapCreated: (GoogleMapController controller) {
        historyMapscontroller.mapsControllerCompleter.complete(controller);
      },
    );
  }
}
