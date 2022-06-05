import 'package:flutter/foundation.dart';
import 'package:social_media_app/analytics/firebase_analytics_tracker.dart';
import 'package:social_media_app/data/models/authentication_model.dart';
import 'package:social_media_app/data/models/authentication_model_impl.dart';
import 'package:social_media_app/data/models/social_model.dart';
import 'package:social_media_app/data/models/social_model_impl.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';

class NewsFeedsBloc extends ChangeNotifier{

  List<NewsFeedVO>? newsFeed;

  final SocialModel _socialModel = SocialModelImpl();
  final AuthenticationModel _authModel = AuthenticationModelImpl();

  bool isDisposed = false;

  NewsFeedsBloc(){

    _socialModel.getNewsFeed().listen((event) {
      print("newsfeed data ============>$event");
        newsFeed = event;
        if(!isDisposed){
          notifyListeners();
        }
    }).onError((error){
      print("get newsfeed data error ===========>${error.toString()}");
    });

    _sendAnalyticsData();

  }

  void _sendAnalyticsData()async{
    await FirebaseAnalyticsTracker().logEvent(homeScreenReached,null);
  }

    void onTapDeletePost(int postId)async{
      await _socialModel.deletePost(postId);
    }

    Future<void> onTapLogout(){
      return _authModel.logout();
    }


  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }

}