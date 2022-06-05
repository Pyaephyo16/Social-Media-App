import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/analytics/firebase_analytics_tracker.dart';
import 'package:social_media_app/data/models/authentication_model.dart';
import 'package:social_media_app/data/models/authentication_model_impl.dart';
import 'package:social_media_app/data/models/social_model.dart';
import 'package:social_media_app/data/models/social_model_impl.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';
import 'package:social_media_app/data/vos/user_vo/user_vo.dart';
import 'package:social_media_app/remote_config/firebase_remote_config.dart';

class AddNewPostBloc extends ChangeNotifier{

///State
String newPostDescription = "";
bool isAddNewPostError = false;
bool isDisposed = false;
bool isLoading = false;
UserVO? loggedInUser;

///Image
File? chosenImageFile;

///For EditMode
bool isInEditMode = false;
String userName = "";
String profilePicture = "";
String editImagePath = "";
NewsFeedVO? newsFeed;

///Color
Color themeColor = Colors.black;

///Model
  final SocialModel socialModel = SocialModelImpl();
  final AuthenticationModel authModel = AuthenticationModelImpl();

  //Firebase Config 
  final FirebaseRemoteConfig _firebaseRemoteConfig = FirebaseRemoteConfig();



  AddNewPostBloc(int? newsFeedId){
    loggedInUser = authModel.getLoggedInUser();
      if(newsFeedId != null){
        isInEditMode = true;
        prepopulateDataForEditMode(newsFeedId);
      }else{
        prepopulateDataForAddNewPost();
      }

      //Firebase
      _sendAnalyticsData(addNewPostScreenReached,null);
      getRemoteConfigAndChangeTheme();
  }

  void getRemoteConfigAndChangeTheme(){
    themeColor = _firebaseRemoteConfig.getThemeColorForRemoteConfig();
    print("theme color ==============> $themeColor");
    _notifySafely();
  }

   void _sendAnalyticsData(String name,Map<String,dynamic>? param)async{
    await FirebaseAnalyticsTracker().logEvent(name,param);
  }

  void prepopulateDataForAddNewPost(){
     userName = loggedInUser?.userName ?? "";
     profilePicture = "https://pbs.twimg.com/profile_images/1392723160924000257/pmTXlZQc_400x400.jpg";
     _notifySafely();
  }

  void prepopulateDataForEditMode(int newsFeedId){
      socialModel.getNewsFeedById(newsFeedId).listen((event) {
          userName = event.userName ?? "";
          profilePicture = event.profilePicture ?? "";
          newPostDescription = event.description ?? "";
          editImagePath = event.postImage ?? "";
          print("image check for edit ===============> ${event.postImage}");
          newsFeed = event;
          _notifySafely();
      });
  }

  
 


    void onNewPostTextChanged(String newText){
        newPostDescription = newText;
    }


    Future<void> onTapAddNewPost(){
        if(newPostDescription.isEmpty || newPostDescription == ""){
           print("post upload error bloc layer ==================================");
            isAddNewPostError = true;
            _notifySafely();
            return Future.error("Error");
        }else{
          isLoading = true;
          _notifySafely();
            isAddNewPostError = false;
            if(isInEditMode){
              return editNewsFeedPost().then((value){
                 print("post edit complete blocc layer ==================================");
                isLoading = false;
                _notifySafely();
                _sendAnalyticsData(editPostAction,{postId: newsFeed?.id.toString() ?? ""});
              }).catchError((error){
                print("post edit bloc layer error ===============> ${error.toString()}");
              });
            }else{
              return createNewNewsFeedPost().then((value){
                print("post upload complete bloc layer ==================================");
                isLoading = false;
                _notifySafely();
                _sendAnalyticsData(addNewPostAction,null);
              }).catchError((error){
                print("post upload bloc layer error ===============> ${error.toString()}");
              });
            }
        }
    }

       Future<dynamic> editNewsFeedPost(){
       newsFeed?.description = newPostDescription;
      (editImagePath == "a") ?  newsFeed?.postImage = chosenImageFile?.path.toString()  : newsFeed?.postImage = editImagePath;
       if(newsFeed != null){
         if(editImagePath == "a"){
         return socialModel.editPost(newsFeed!,true).then((value){
           print("edit post bloc layer completet =====================");
           return value;
         }).catchError((error){
            print("edit post bloc layer error ===================== ${error.toString()}");
         });
         }else{
           print("no change image ==========> ${newsFeed!.postImage}");
           return socialModel.editPost(newsFeed!,false).then((value){
             print("edit post bloc layer completet =====================");
           return value;
           }).catchError((error){
            print("edit post bloc layer error ===================== ${error.toString()}");
         });
         }
       }else{
         return Future.error("Error");
       }
    }

    Future<void> createNewNewsFeedPost(){
    return socialModel.addNewPost(newPostDescription,chosenImageFile);
    }

    ///Image
    
    void onImageChosen(File imageFile){
      print("image path ==========> $imageFile");
        chosenImageFile = imageFile;
        editImagePath = "a";
      _notifySafely();
    }

    void onTapDeleteImage(){
      chosenImageFile = null;
      editImagePath = "";
      _notifySafely();
    }



  void _notifySafely(){
    if(!isDisposed){
      notifyListeners();
     }
  }


    @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }

}