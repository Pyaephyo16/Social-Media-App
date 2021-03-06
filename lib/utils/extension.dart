import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension NavigationUtility on Widget{

  void navigateToNextScreen(BuildContext context,Widget nextScreen){
    Navigator.push(context,
     MaterialPageRoute(builder: (context) => nextScreen));
  }


  void showSnackBarWithMessage(BuildContext context,String message){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

}