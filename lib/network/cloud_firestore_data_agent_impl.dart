import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media_app/data/models/authentication_model.dart';
import 'package:social_media_app/data/models/authentication_model_impl.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';
import 'package:social_media_app/data/vos/user_vo/user_vo.dart';
import 'package:social_media_app/network/social_data_agent.dart';

///News Feed Collection
const newsFeedCollection = "newsfeed";
const userCollection = "users";
const fileUploadRef = 'uploads';

class CloudFirestoreDataAgentImpl extends SocialDataAgent{

  ///FireStore
    final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  ///Storage
  final FirebaseStorage fireStorage = FirebaseStorage.instance;

  //Auth
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Future<void> addNewPost(NewsFeedVO newPost) {
    return _fireStore
      .collection(newsFeedCollection)
      .doc(newPost.id.toString())
      .set(newPost.toJson());
  }

  @override
  Future<void> deletePost(int postId) {
   return _fireStore
          .collection(newsFeedCollection)
          .doc(postId.toString())
          .delete();
  }

  @override
  Stream<List<NewsFeedVO>> getNewsFeed() {
    return _fireStore
        .collection(newsFeedCollection)
        .snapshots()
        .map((querySnapshot){
          return querySnapshot.docs.map<NewsFeedVO>((document){
            print("document cloud newsfeed check ========> ${document.data()}");
            return NewsFeedVO.fromJson(document.data());
          }).toList();
        });
  }

  @override
  Stream<NewsFeedVO> getNewsFeedById(int newsFeedId) {
    return _fireStore
        .collection(newsFeedCollection)
        .doc(newsFeedId.toString())
        .get()
        .asStream()
        .where((documentSnapshot) => documentSnapshot.data() != null)
        .map((documentSnapshot){
          return NewsFeedVO.fromJson(documentSnapshot.data()!);
        });
  }

  @override
  Future<String> uploadFileToDatabase(File image) {
    return fireStorage 
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
        .then((credential) =>
         credential.user?..updateDisplayName(newUser.userName))
        .then((user){
    print("register cloud firestore complete ========================");
          newUser.id = user?.uid ?? "";
          // final User? user = auth.currentUser;
          //   print(user?.uid);
          //   newUser.id = user?.uid;
          _addNewUser(newUser);
        });
  }

  Future<void> _addNewUser(UserVO user){
    print("cloud firesotre register =================> $user");
    return _fireStore
        .collection(userCollection)
        .doc(user.id.toString())
        .set(user.toJson());
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




}