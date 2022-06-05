import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';
import 'package:social_media_app/data/vos/user_vo/user_vo.dart';

abstract class SocialDataAgent{

    ///NewsFeed
  Stream<List<NewsFeedVO>> getNewsFeed();
  Future<void> addNewPost(NewsFeedVO newPost);
  Future<void> deletePost(int postId);
  Stream<NewsFeedVO> getNewsFeedById(int newsFeedId);
  Future<String> uploadFileToDatabase(File image);


  ///Authentication
  Future registerNewUser(UserVO newUser);
  Future login(String email,String password);
  bool isLoggedIn();
  UserVO getLoggedInUser();
  Future logout();

}