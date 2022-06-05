import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_installations/firebase_installations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media_app/data/models/authentication_model.dart';
import 'package:social_media_app/data/models/authentication_model_impl.dart';
import 'package:social_media_app/fcm/fcm_service.dart';
import 'package:social_media_app/pages/login_page.dart';
import 'package:social_media_app/pages/news_fedd_page.dart';
import 'package:social_media_app/pages/register_page.dart';

void main()async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FCMService().listenForMessages();

  var firebaseInstallationId = 
  await FirebaseInstallations.id ?? 'Unknown Installation id';

  debugPrint("fire installation id ================> $firebaseInstallationId");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final _authModel = AuthenticationModelImpl();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: GoogleFonts.ubuntu().fontFamily),
      home: (_authModel.isLoggedIn()) 
      ?  NewsFeedPage()
      :  LoginPage(),
    );
  }
}
