import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/blocs/news_feeds_bloc.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';
import 'package:social_media_app/pages/add_new_post_page.dart';
import 'package:social_media_app/pages/login_page.dart';
import 'package:social_media_app/pages/text_detection_page.dart';
import 'package:social_media_app/resources/dimens.dart';
import 'package:social_media_app/viewitems/news_feed_item_view.dart';

class NewsFeedPage extends StatelessWidget {
  const NewsFeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NewsFeedsBloc(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: Container(
            margin: const EdgeInsets.only(
              left: 8,
            ),
            child: const Text(
              "Social",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: TEXT_HEADING_1X,
                color: Colors.black,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: (){
                navigateToNextScreen(context,TextDetectionPage());
              },
               icon: Icon(Icons.face,size: 26,color: Colors.black,),
               ),
            GestureDetector(
              onTap: () {
                /// TODO : - Handle Search Here
              },
              child: Container(
                margin: const EdgeInsets.only(
                  right: 8,
                  left: 8
                ),
                child: const Icon(
                  Icons.search,
                  color: Colors.grey,
                  size: MARGIN_LARGE,
                ),
              ),
            ),
            Consumer<NewsFeedsBloc>(
              builder: (context,NewsFeedsBloc bloc,child) =>
               IconButton(
                onPressed: (){
                  bloc.onTapLogout().then((value) => navigateToNextScreen(context, LoginPage()));
                },
                 icon: Icon(Icons.logout,color: Colors.red,size: MARGIN_LARGE,),
                 ),
            ),
          ],
        ),
        body: Container(
          color: Colors.white,
          child: Consumer<NewsFeedsBloc>(
            builder: (context,NewsFeedsBloc bloc,child) =>
             ListView.separated(
              padding: const EdgeInsets.symmetric(
                vertical: MARGIN_LARGE,
                horizontal: MARGIN_LARGE,
              ),
              itemBuilder: (context, index) {
                return NewsFeedItemView(
                  newsFeed: bloc.newsFeed?[index] ?? NewsFeedVO.empty(),
                  onTapEdit: (newsFeedId){
                      Future.delayed(Duration(milliseconds: 1000,)).then((value){
                        navigateToNextScreen(context, AddNewPostPage(newsFeedId: newsFeedId,));
                      });
                  },
                  onTapDelete: (postId){
                    bloc.onTapDeletePost(postId);
                  },
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: MARGIN_XLARGE,
                );
              },
              itemCount: bloc.newsFeed?.length ?? 0,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: (){
            navigateToNextScreen(context,AddNewPostPage(newsFeedId: null,));
            //FirebaseCrashlytics.instance.crash();
          },  
          child: Icon(Icons.add,size: 32,),
        ),
      ),
    );
  }

  Future<dynamic> navigateToNextScreen(BuildContext context,Widget widgetPage) {
    return Navigator.push(context,
          MaterialPageRoute(builder: (context) => widgetPage),
          );
  }
}
