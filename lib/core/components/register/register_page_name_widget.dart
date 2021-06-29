import 'package:flutter/material.dart';

class RegisterPageNameWidget extends StatelessWidget {
  const RegisterPageNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Benutzername",
          hintStyle: TextStyle(
            fontSize: 30,
          ),
        ),
        style: TextStyle(
          fontSize: 30,
        ),
      ),
    );
  }
}
