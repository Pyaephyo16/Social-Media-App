import 'package:flutter/material.dart';

class LabelAndTextFieldView extends StatelessWidget {

  final String label;
  final String hint;
  final Function(String) onChanged;
  final TextEditingController controller;

  LabelAndTextFieldView({
    required this.label,
    required this.hint,
    required this.onChanged,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
        style:const TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
        ),
       const SizedBox(height: 8,),
        TextField(
          controller: controller,
          onChanged: (text){
            onChanged(text);
          },
          style:const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
          obscureText: (label == "Password") ? true : false,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:const TextStyle(
              color: Colors.grey,
            ),
            border:const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: Colors.black,width: 2)
            )
          ),
        )
      ],
    );
  }
}