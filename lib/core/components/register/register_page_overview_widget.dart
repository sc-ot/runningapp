import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPageOverviewWidget extends StatelessWidget {
  const RegisterPageOverviewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: Get.height * 0.5,
        child: Card(
          color: Colors.white,
          child: Column(
            children: [
              ListTile(
                title: Text("Benutzername"),
              ),
              ListTile(
                title: Text("Passwort"),
              ),
              ListTile(
                title: Text("Größe"),
              ),
              ListTile(
                title: Text("Gewicht"),
              ),
              ListTile(
                title: Text("Alter"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
