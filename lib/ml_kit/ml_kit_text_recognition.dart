import 'dart:io';

import 'package:google_ml_kit/google_ml_kit.dart';

class MlKitTextRecognition{

  static final MlKitTextRecognition _singleton = MlKitTextRecognition._internal();

  factory MlKitTextRecognition(){
    return _singleton;
  }

  MlKitTextRecognition._internal();

  void detectTexts(File imageFile)async{

    InputImage inputImage = InputImage.fromFile(imageFile);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    final RecognizedText recognizedText = await textDetector.processImage(inputImage);
    recognizedText.blocks.forEach((element) {
        print("Recognized Text >>>>>>>> ${element.text}");
    });

  }

}