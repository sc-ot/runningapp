import 'package:bestpractice/core/components/login/register_controller.dart';
import 'package:bestpractice/core/utils/uihandler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller.dart';

class RegisterPage extends StatelessWidget implements UIHandler {
   RegisterPage({Key? key}) : super(key: key);

  final registerController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<RegisterController>(
        init: registerController,
        builder: (registerController) {
          return handleUi(
            idle: idleStateUi(),
            loading: loadingStateUi(),
            success: successStateUi(),
            error: errorStateUi(),
            internetConnectivity: internetConnectivityStateUi(),
            noInternetConnectivity: noInternetConnectivityStateUi(),
          );
        },
      ),
    );
  }

  @override
  Widget errorStateUi() {
   return Text("ERROR!");
  }


  @override
  Widget idleStateUi() {
   return Padding(
     padding: const EdgeInsets.all(32.0),
     child: Column(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
         TextField(
           controller: registerController.username,
         ),
         TextField(
            controller: registerController.password,
         ),
         SizedBox(height: 30,),
         OutlinedButton(
           onPressed: (){
             registerController.register();
           },
           child: Text("Registrieren"),
         )

       ],
     ),
   );
  }

  @override
  Widget internetConnectivityStateUi() {
   return idleStateUi();
  }

  @override
  Widget loadingStateUi() {
   return CircularProgressIndicator();
  }

  @override
  Widget noInternetConnectivityStateUi() {
 return idleStateUi();
  }

  @override
  Widget successStateUi() {
  return idleStateUi();
  }

   @override
  Widget handleUi({required Widget idle, required Widget loading, required Widget success, required Widget error, required Widget internetConnectivity, required Widget noInternetConnectivity}) {
   switch (registerController.state.runtimeType) {
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
      
      default:
        Container();
    }
    return Container();
  }
}
