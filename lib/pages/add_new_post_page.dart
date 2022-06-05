import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/blocs/add_new_post_bloc.dart';
import 'package:social_media_app/blocs/news_feeds_bloc.dart';
import 'package:social_media_app/resources/dimens.dart';
import 'package:social_media_app/viewitems/news_feed_item_view.dart';
//import 'package:path/path.dart' hide context,Context;

class AddNewPostPage extends StatelessWidget {

    final int? newsFeedId;

    AddNewPostPage({
      required this.newsFeedId
    });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddNewPostBloc(newsFeedId),
      child: Selector<AddNewPostBloc,bool>(
        selector: (context,bloc) => bloc.isLoading,
        shouldRebuild: (previous,next) => previous != next,
        builder: (context,isLoading,child) =>
         Stack(
          children: [
            Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                 icon: Icon(Icons.chevron_left,size: 32,color: Colors.black,),
                 ),
               title: Text("Add new Post",
               style: TextStyle(
                 fontSize: 20,
                 fontWeight: FontWeight.bold,
               ),),  
              ),
              body: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ProfileImageAndNameView(),
                    SizedBox(height: MARGIN_LARGE,),
                    AddNewPostTextFieldView(),
                    SizedBox(height: MARGIN_MEDIUM_2,),
                    PostDescriptionErrorView(),
                    SizedBox(height: MARGIN_LARGE,),
                    PostUploadImage(),
                    SizedBox(height: MARGIN_LARGE,),
                    PostButtonView(),
                  ],
                ),
              ),
            ),
          
            Visibility(
              visible: isLoading,
              child: Container(
                color: Colors.black12,
                child: Center(
                  child: LoadingView(),
                ),
              )
              ),
          ],
        ),
      ),
    );
  }
}

class LoadingView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      child:const Center(
        child: SizedBox(
          width: MARGIN_XXLARGE,
          height: MARGIN_XXLARGE,
          child: LoadingIndicator(
            indicatorType: Indicator.ballRotate,
            colors: [Colors.white],
            strokeWidth: 2,
            backgroundColor: Colors.transparent,
            pathBackgroundColor: Colors.black,
            ),
        ),
      ),
    );
  }
}


  class PostUploadImage extends StatelessWidget {
  
    @override
    Widget build(BuildContext context) {
      return Consumer<AddNewPostBloc>(
        builder: (context,AddNewPostBloc bloc,child) =>
          Container(
            width: double.infinity,
            height: 200,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              border: Border.all(width: 1,color: Colors.black),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    child: (bloc.chosenImageFile == null || bloc.editImagePath == "") ? 
                    GestureDetector(
                      onTap: ()async{
                          final ImagePicker _picker = ImagePicker();
                          final XFile? image = await _picker.pickImage(source: ImageSource.gallery,imageQuality: 80);
                          //final PickedFile? image = await _picker.getImage(source: ImageSource.gallery);
                          if(image != null){
                            bloc.onImageChosen(File(image.path,));
                          }
                      },
                      child: Center(
                        child: SizedBox(
                          height: 200,
                          child: Center(
                            child: (bloc.editImagePath == null || bloc.editImagePath == "") ?
                             Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQw7Dh7qCWBSGcz4WlVVeVvK9A3cotmHme5aQ&usqp=CAU",)
                          : 
                         Image.network(bloc.editImagePath),
                          ),
                        ),
                      ),
                    ) 
                    : SizedBox(
                      height: 200,
                      child: Image.file(bloc.chosenImageFile!,
                      fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),


                Align(
                  alignment: Alignment.topRight,
                  child: Visibility(
                    visible: (bloc.chosenImageFile != null) ? true : (bloc.isInEditMode == true) ? true : false,
                    child: GestureDetector(
                        onTap: (){
                          bloc.onTapDeleteImage();
                        },
                        child: Icon(Icons.delete,color: Colors.red,size: 32,),
                      ),
                    ),
                )
              ],
            ),
          ),
      );
    }
  }


class ProfileImageAndNameView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewPostBloc>(
      builder: (context,AddNewPostBloc bloc,child) =>
       Row(
        children: [
          CircleAvatar(
        backgroundImage: NetworkImage(bloc.profilePicture),
        radius: MARGIN_LARGE,
      ),
      SizedBox(width: 8,),
      Text(bloc.userName,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      ),
        ],
      ),
    );
  }
}


class AddNewPostTextFieldView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewPostBloc>(
      builder: (context,AddNewPostBloc bloc,child) =>
       SizedBox(
        height: 180,
        child: TextField(
          controller: TextEditingController(text: bloc.newPostDescription),
          maxLines: 24,
          onChanged: (text){
            bloc.onNewPostTextChanged(text);
          },
          decoration: InputDecoration(
            hintText: "What\,s on your mind?",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              borderSide: BorderSide(width: 1,color: Colors.grey),
            )
          ),
        ),
      ),
    );
  }
}

class PostDescriptionErrorView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewPostBloc>(
      builder: (context,AddNewPostBloc bloc,child) =>
      Visibility(
        visible: bloc.isAddNewPostError,
        child: const Text(
          "Post shoudn\'t be empty",
        style: TextStyle(
          fontSize: 14,
          color: Colors.red,
          fontWeight: FontWeight.w500,
        ),
        ),
      ),
    );
  }
}


class PostButtonView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewPostBloc>(
      builder: (context,AddNewPostBloc bloc,child) =>
       GestureDetector(
        onTap: (){
           bloc.onTapAddNewPost().then((value) => Navigator.pop(context));
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: bloc.themeColor,
          ),
          child: Center(
            child: Text("Post",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            ),
          ),
        ),
      ),
    );
  }
}