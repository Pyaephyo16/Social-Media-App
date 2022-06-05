import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:social_media_app/data/models/authentication_model.dart';
import 'package:social_media_app/data/models/authentication_model_impl.dart';

class LoginBloc extends ChangeNotifier{

  ///State
  bool isLoading = false;
  String email = "";
  String password = "";
  bool isDisposed = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final AuthenticationModel model = AuthenticationModelImpl();

   Future onTapLogin(){
    _showLoading();
    return model.login(emailController.text,passwordController.text).whenComplete(() => _hideLoading());
  }

  void onChangedEmail(String newEmail){
    email = newEmail;
     print("enter email =======> $email");
  }

  void onChangedPassword(String newPassword){
    password = newPassword;
    print("enter pswd =======> $password");
  }



  void _hideLoading(){
    isLoading = false;
    _notifySafely();
  }

  void _showLoading(){
    isLoading = true;
    _notifySafely();
  }

  void _notifySafely(){
    if(!isDisposed){
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
    isDisposed = true;
  }

}