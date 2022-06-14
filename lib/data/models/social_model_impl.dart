import 'dart:io';

import 'package:social_media_app/data/models/authentication_model.dart';
import 'package:social_media_app/data/models/authentication_model_impl.dart';
import 'package:social_media_app/data/models/social_model.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';
import 'package:social_media_app/network/cloud_firestore_data_agent_impl.dart';
import 'package:social_media_app/network/real_time_database_data_agent_impl.dart';
import 'package:social_media_app/network/social_data_agent.dart';

class SocialModelImpl extends SocialModel{

static final SocialModelImpl _singleton = SocialModelImpl._internal();

factory SocialModelImpl(){
  return _singleton;
}

SocialModelImpl._internal();

    ///Other model
    final AuthenticationModel authModel = AuthenticationModelImpl();


      SocialDataAgent dataAgent = RealTimeDatabaseDataAgentImpl();
      //SocialDataAgent dataAgent = CloudFirestoreDataAgentImpl();

  @override
  Stream<List<NewsFeedVO>> getNewsFeed(){
   return dataAgent.getNewsFeed();
  }

  @override
  Future<void> addNewPost(String description,File? imageFile){
     if(imageFile != null){
       return dataAgent
            .uploadFileToDatabase(imageFile)
            .then((downloadUrl) => crafNewsFeedVO(description, downloadUrl))
            .then((newPost){
              return dataAgent.addNewPost(newPost).then((value){
                print("add post complete social data layer =================");
                return value;
              }).catchError((error){
              print("add new post data layer error ==========> ${error.toString()}");
            });
            });
     }else{
       return crafNewsFeedVO(description,"").then((newPost){
         return dataAgent.addNewPost(newPost).then((value){
         print("add post complete social data layer =================");
            return value;
         }).catchError((error){
         print("add new post data layer error ==========> ${error.toString()}");
       });
       });
     }
  }

  Future<NewsFeedVO> crafNewsFeedVO(String description,String imageFile){
    var currentMilliseconds = DateTime.now().millisecondsSinceEpoch;
    var newPost = NewsFeedVO(
      currentMilliseconds,
       description,
        "https://pbs.twimg.com/profile_images/1392723160924000257/pmTXlZQc_400x400.jpg",
         authModel.getLoggedInUser().userName,
          imageFile,
          );
       return Future.value(newPost);
  }

  @override
  Future<void> deletePost(int postId) {
    return dataAgent.deletePost(postId);
  }

  @override
  Stream<NewsFeedVO> getNewsFeedById(int newsFeedId){
    return dataAgent.getNewsFeedById(newsFeedId);
  }

  @override
  Future<void> editPost(NewsFeedVO newsFeed,bool isChangeImage){
      if(isChangeImage == true){
       return dataAgent
            .uploadFileToDatabase(File(newsFeed.postImage!))
            .then((downloadUrl) => editSetupNewsFeedVO(newsFeed, downloadUrl))
            .then((newPost){
             return dataAgent.addNewPost(newPost).then((value){
              print("edit post complete social data layer =================");
               return value;
             }).catchError((error){
              print("edit post data layer error ${error.toString()}");
            });
            });
     }else{
       return dataAgent.addNewPost(newsFeed).then((value){
         print("edit post complete social data layer =================");
         return value;
       }).catchError((error){
              print("edit post data layer error ${error.toString()}");
            });
     }
    //return dataAgent.addNewPost(newsFeed);
  }

  Future<NewsFeedVO> editSetupNewsFeedVO(NewsFeedVO newsFeed,String downloadUrl){
    var newPost = NewsFeedVO(
      newsFeed.id,
       newsFeed.description,
        newsFeed.profilePicture,
        newsFeed.userName,
          downloadUrl,
          );
       return Future.value(newPost);
  }



}