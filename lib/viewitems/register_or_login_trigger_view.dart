import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterOrLoginTriggerView extends StatelessWidget {

  final String title;
  final Function onclick;

  RegisterOrLoginTriggerView({
    required this.title,
    required this.onclick,
    });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
         text: "Don\'t have an account? ",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
          children: <TextSpan>[
            TextSpan(
              text: title,
              recognizer: TapGestureRecognizer()
              ..onTap = (){
                onclick();
              },
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              )
            )
          ],
        ),
      ),
    );
  }
}