import 'package:bestpractice/core/components/history/history_controller.dart';
import 'package:bestpractice/core/utils/routes.dart';
import 'package:bestpractice/core/utils/uihandler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import '../../../controller.dart';

class HistoryPage extends StatelessWidget implements UIHandler {
  HistoryPage({Key? key}) : super(key: key);

  final HistoryController historyController = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<HistoryController>(
        init: historyController,
        builder: (historyController) {
          return SafeArea(
            child: handleUi(
            ),
          );
        },
      ),
    );
  }

  @override
  Widget errorStateUi() {
    return Text("ERROR");
  }

  @override
  Widget handleUi() {
    switch (historyController.state.runtimeType) {
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

  Widget idleStateUi() {
    return loadingStateUi();
  }

  @override
  Widget internetConnectivityStateUi() {
    return Text("Internet");
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
    return GetBuilder(
      init: historyController,
      builder: (controller) {
        return AnimationLimiter(
          child: ListView.builder(
            itemCount: historyController.runs.length,
            itemBuilder: (BuildContext context, int index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 140,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Mi., "),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text("21.03.21"),
                                ],
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Container(
                                width: 1,
                                color: Colors.green,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.av_timer_sharp),
                                        Text(
                                            "${historyController.runs[index].runHour}h:${historyController.runs[index].runMinutes}m:${historyController.runs[index].runSeconds}s"),
                                        Spacer(),
                                        Icon(Icons.speed),
                                        Text(
                                            "${historyController.runs[index].runDistance.toStringAsFixed(2)} km"),
                                        SizedBox(
                                          width: 16,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.av_timer_sharp),
                                        Text(
                                            "${historyController.runs[index].avgSpeed.toStringAsFixed(2)} km/h"),
                                        Spacer(),
                                        Icon(Icons.speed),
                                        Text(
                                            "${historyController.runs[index].caloriesBurned.toStringAsFixed(2)}"),
                                        SizedBox(
                                          width: 16,
                                        ),
                                      ],
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.toNamed(Routes.HISTORY_MAPS, arguments: {
                                          "positions" : historyController.runs[index].positions,
                                        });
                                      },
                                      child: Text("Auf Karte anzeigen"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
