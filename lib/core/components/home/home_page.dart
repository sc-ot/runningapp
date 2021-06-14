import 'package:bestpractice/controller.dart';
import 'package:bestpractice/core/utils/uihandler.dart';
import 'package:bestpractice/core/components/home/uihandler_home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'home_controller.dart';

class HomePage extends StatelessWidget implements UIHandlerHome {
  HomePage() : super();
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: homeController,
      builder: (homeController) {
        return Scaffold(
          floatingActionButton: Transform.scale(
            scale: 1.3,
            child: FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.search),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            notchMargin: 14,
            color: Colors.red,
            shape: CircularNotchedRectangle(),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () => {},
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: handleUi(
              idle: idleStateUi(),
              loading: loadingStateUi(),
              success: successStateUi(),
              error: errorStateUi(),
              internetConnectivity: internetConnectivityStateUi(),
              noInternetConnectivity: noInternetConnectivityStateUi(),
              positionChange: successStateUi(),
            ),
          ),
        );
      },
    );
  }

  Widget loadingIndicator() {
    return Center(child: const CircularProgressIndicator());
  }


  Widget positionChangedStateUi() {
    return successStateUi();
  }

  @override
  Widget errorStateUi() {
    return Text("FEHLER");
  }

  @override
  Widget idleStateUi() {
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (homeController) {
          return Stack(
            children: [
              PageView(
                children: [
                  GoogleMap(
                    mapType: MapType.terrain,
                    polylines: {
                      Polyline(
                        polylineId: PolylineId("route"),
                        color: Colors.red,
                        width: 5,
                        points: homeController.positions,
                      ),
                    },
                    initialCameraPosition: homeController.cameraPosition,
                    markers: {
                      homeController.marker,
                    },
                    onMapCreated: (GoogleMapController controller) {
                      homeController.mapsControllerCompleter
                          .complete(controller);
                    },
                  ),
                  Container(
                    color: Colors.red,
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: Get.height * 0.1,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("KM/H: + " +
                                (homeController.speed * 3.6)
                                    .toStringAsFixed(2)),
                            Spacer(),
                            Text(
                              homeController.city,
                              style: TextStyle(fontSize: 20),
                            ),
                            Spacer(),
                            Text(
                              homeController.titleCurrentTime,
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(homeController.weatherTemperature
                                    .toStringAsFixed(2) +
                                "°C"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget internetConnectivityStateUi() {
    return Text(" INTERNET");
  }

  @override
  Widget loadingStateUi() {
    return Center(child: CircularProgressIndicator(
      backgroundColor: Colors.red,
    ));
  }

  @override
  Widget noInternetConnectivityStateUi() {
    return Text("KEIN INTERNET!");
  }

    @override
  Widget positionChangeStateUi() {
    return successStateUi();
  }

  @override
  Widget successStateUi() {
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (homeController) {
          return Stack(
            children: [
              GoogleMap(
                mapType: MapType.terrain,
                polylines: {
                  Polyline(
                    polylineId: PolylineId("route"),
                    color: Colors.red,
                    width: 5,
                    points: homeController.positions,
                  ),
                },
                initialCameraPosition: homeController.cameraPosition,
                markers: {
                  homeController.marker,
                },
                onMapCreated: (GoogleMapController controller) {
                  homeController.mapsControllerCompleter.complete(controller);
                },
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: Get.height * 0.1,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("KM/H: + " +
                                (homeController.speed * 3.6)
                                    .toStringAsFixed(2)),
                            Spacer(),
                            Text(
                              homeController.city,
                              style: TextStyle(fontSize: 20),
                            ),
                            Spacer(),
                            Text(
                              homeController.titleCurrentTime,
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(homeController.weatherTemperature
                                    .toStringAsFixed(2) +
                                "°C"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget handleUi({required Widget idle, required Widget loading, required Widget success, required Widget error, required Widget internetConnectivity, required Widget noInternetConnectivity, required Widget positionChange}) {
   switch (homeController.state.runtimeType) {
      case IDLE:
        return idle;
      case LOADING:
        return loading;
      case SUCCESS:
        return success;
      case ERROR:
        return error;
      case INTERNET_CONNECTIVITY:
        return internetConnectivity;
      case NO_INTERNET_CONNECTIVITY:
        return noInternetConnectivity;
      case POSITION_CHANGE:
      return positionChange;
      default:
        Container();
    }
    return Container();
  }


}