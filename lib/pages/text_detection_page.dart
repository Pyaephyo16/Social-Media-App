import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/blocs/text_detection_bloc.dart';
import 'package:social_media_app/pages/login_page.dart';
import 'package:social_media_app/resources/dimens.dart';
import 'package:social_media_app/utils/extension.dart';

class TextDetectionPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TextDetectionBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leadingWidth: 144,
          leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
           child: Row(
             children: [
               Icon(Icons.chevron_left,color: Colors.black,size: 32,),
               Text("Back",style: TextStyle(
                 fontSize: 16,
                 fontWeight: FontWeight.bold,
                 color: Colors.black,
               ),)
             ],
           ), 
          ),
        ),
       body: Container(
         padding: EdgeInsets.symmetric(horizontal: MARGIN_LARGE),
         child: Center(
           child: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
               Consumer<TextDetectionBloc>(
                 builder: (context,TextDetectionBloc bloc,child) =>
                 Visibility(
                   visible: bloc.chosenImageFile !=null,
                   child: Image.file(
                     bloc.chosenImageFile ?? File(""),
                   width: 300,
                   height: 300,
                   )
                   ),
               ),
              const SizedBox(height: MARGIN_LARGE,),
              Consumer<TextDetectionBloc>(
                builder: (context,TextDetectionBloc bloc,child) =>
                  // GestureDetector(
                  //   onTap: (){
                  //     ImagePicker().pickImage(source: ImageSource.gallery)
                  //     .then((pickedImageFile)async{
                  //       var bytes =await pickedImageFile?.readAsBytes();
                  //       bloc.onImageChosen(
                  //         File(pickedImageFile?.path ?? ""),
                  //         bytes ?? Uint8List(0)
                  //       );
                  //     }).catchError((error){
                  //       showSnackBarWithMessage(context,"Image cannot be picked");
                  //     });
                  //   },
                  //   child: ButtonView(
                  //     title: "Choose Image",
                  //      onClick: (){},
                  //      ),
                  // ),
                  ButtonView(
                    title: "Pick Image",
                     onClick: (){
                        ImagePicker().pickImage(source: ImageSource.gallery)
                      .then((pickedImageFile)async{
                        var bytes =await pickedImageFile?.readAsBytes();
                        bloc.onImageChosen(
                          File(pickedImageFile?.path ?? ""),
                          bytes ?? Uint8List(0)
                        );
                      }).catchError((error){
                        showSnackBarWithMessage(context,"Image cannot be picked");
                      });
                     })
                ),
             ],
           ),
         ),
       ), 
      ),
    );
  }
}