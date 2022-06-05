import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:social_media_app/data/models/authentication_model.dart';
import 'package:social_media_app/data/models/authentication_model_impl.dart';

class RegisterBloc extends ChangeNotifier{

  ///State
    bool isLoading = false;
  String email = "";
  String password = "";
  String userName = "";
  bool isDisposed = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


 final AuthenticationModel model = AuthenticationModelImpl();

    Future onTapRegister(){
    _showLoading();
    //return model.register(email,userName,password).whenComplete(() => _hideLoading());
    return model.register(emailController.text,nameController.text,passwordController.text)
    .whenComplete(() => _hideLoading());
  }

  void onChangedEmail(String newEmail){
    email = newEmail;
     print("enter email =======> $email");
  }

  void onChangedPassword(String newPassword){
    password = newPassword;
     print("enter password =======> $password");
  }

  void onChangedUserName(String newUserName){
    userName = newUserName;
     print("enter username =======> $userName");
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
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
    isDisposed = true;
  }

}