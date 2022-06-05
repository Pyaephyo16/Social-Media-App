import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';
import 'package:social_media_app/data/vos/user_vo/user_vo.dart';
import 'package:social_media_app/network/social_data_agent.dart';

///Database Path
const newsFeedPath = 'newsfeed';
const usersPath = "users";
const fileUploadRef = 'uploads';

class RealTimeDatabaseDataAgentImpl extends SocialDataAgent{

  static final RealTimeDatabaseDataAgentImpl _singleton = RealTimeDatabaseDataAgentImpl._internal();
  
  factory RealTimeDatabaseDataAgentImpl(){
    return _singleton;
  }
  
  RealTimeDatabaseDataAgentImpl._internal();

    ///Database
  var databaseRef = FirebaseDatabase.instance.reference();

  ///Storage
  var firebaseStorage = FirebaseStorage.instance;
  
    ///Auth
    FirebaseAuth auth = FirebaseAuth.instance;


  @override
  Stream<List<NewsFeedVO>> getNewsFeed(){
    return databaseRef.child(newsFeedPath).onValue.map((event){
      /// event.snapshot.value (Map<String,dynamic>) ==> values (List<Map<String,dynamic>>)
      ///  ==> NewsFeedVO.fromJson() (List<NewsFeedVO>)
      return event.snapshot.value.values.map<NewsFeedVO>((element){
          return NewsFeedVO.fromJson(Map<String,dynamic>.from(element));
      }).toList();
    });
  }

  @override
  Future<void> addNewPost(NewsFeedVO newPost) {
    return databaseRef.
    child(newsFeedPath).
    child(newPost.id.toString())
    .set(newPost.toJson());
  }

  @override
  Future<void> deletePost(int postId) {
    return databaseRef
    .child(newsFeedPath)
    .child(postId.toString())
    .remove();
  }

  @override
  Stream<NewsFeedVO> getNewsFeedById(int newsFeedId) {
    return databaseRef.child(newsFeedPath)
      .child(newsFeedId.toString())
      .once()
      .asStream()
      .map((snapshot){
        return NewsFeedVO.fromJson(Map<String,dynamic>.from(snapshot.value));
      });
  }


  @override
  Future<String> uploadFileToDatabase(File image) {
    return firebaseStorage
        .ref(fileUploadRef)
        .child("${DateTime.now().millisecondsSinceEpoch}")
        .putFile(image)
        .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());
  }

  ///Auth
 
  @override
  Future registerNewUser(UserVO newUser) {
    return auth
        .createUserWithEmailAndPassword(email: newUser.email ?? "", password: newUser.password ?? "")
        .then((credential) => credential.user?..updateDisplayName(newUser.userName))
        .then((user){
           print("register real time db complete ========================");
          newUser.id = user?.uid ?? "";
          _addNewUser(newUser);
        });
  }

  Future<void> _addNewUser(UserVO newUser){
    return databaseRef
        .child(usersPath)
        .child(newUser.id.toString())
        .set(newUser.toJson());
  }

  @override
  Future login(String email, String password) {
    return auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  UserVO getLoggedInUser() {
    return UserVO(
      id: auth.currentUser?.uid,
      email: auth.currentUser?.email,
      userName: auth.currentUser?.displayName,
    );
  }

  @override
  bool isLoggedIn() {
    return auth.currentUser != null;
  }


  @override
  Future logout() {
   return auth.signOut();
  }

 



     // @override
  // Stream<List<NewsFeedVO>> getNewsFeed(){
  //   return databaseRef.child(newsFeedPath).onValue.map((event){
  //     List<Object?> temp = event.snapshot.value as List<Object?>;
  //      print("event check ==============> ${temp.length}  ${event.snapshot.value}");
  //    return temp.map<NewsFeedVO>((data){
  //          Map<String,dynamic> test = data as Map<String,dynamic>;
  //       print("Data check =============> $test");
  //      return NewsFeedVO.fromJson(Map<String,dynamic>.from(test));
  //     }).toList();
  //   });
  // }

 

  
}