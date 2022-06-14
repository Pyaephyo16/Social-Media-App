import 'package:social_media_app/data/models/authentication_model.dart';
import 'package:social_media_app/data/vos/user_vo/user_vo.dart';
import 'package:social_media_app/network/cloud_firestore_data_agent_impl.dart';
import 'package:social_media_app/network/real_time_database_data_agent_impl.dart';
import 'package:social_media_app/network/social_data_agent.dart';

class AuthenticationModelImpl extends AuthenticationModel{

  static final AuthenticationModelImpl _singleton = AuthenticationModelImpl._internal();

  factory AuthenticationModelImpl(){
    return _singleton;
  }

  AuthenticationModelImpl._internal();

  SocialDataAgent dataAgent = RealTimeDatabaseDataAgentImpl();
   //SocialDataAgent dataAgent = CloudFirestoreDataAgentImpl();


      @override
  Future<void> register(String email, String userName, String password) {
    print("register check data ========> ${email} ${userName} ${password}");
    return craftUserVO(email, userName, password).then((user){
      print("register with auth complete =======================================");
      return dataAgent.registerNewUser(user);
    });
  }

  Future<UserVO> craftUserVO(String email,String name,String password){
    var newUser = UserVO(
      id: "",
      userName: name,
      email: email,
      password: password,
    );
    return Future.value(newUser);
  }


  @override
  Future<void> login(String email, String password) {
   return dataAgent.login(email, password);
  }

  @override
  UserVO getLoggedInUser() {
    return dataAgent.getLoggedInUser();
  }

  @override
  bool isLoggedIn() {
    return dataAgent.isLoggedIn();
  }


  @override
  Future<void> logout() {
    return dataAgent.logout();
  }

}