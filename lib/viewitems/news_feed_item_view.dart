import 'package:flutter/material.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';
import 'package:social_media_app/resources/dimens.dart';
import 'package:social_media_app/resources/images.dart';

class NewsFeedItemView extends StatelessWidget {

  final NewsFeedVO newsFeed;
  final Function(int) onTapDelete;
  final Function(int) onTapEdit;

  NewsFeedItemView({
    required this.newsFeed,
    required this.onTapDelete,
    required this.onTapEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ProfileImageView(
              profileImage: newsFeed.profilePicture ?? "",
            ),
            SizedBox(
              width: MARGIN_MEDIUM_2,
            ),
            NameLocationAndTimeAgoView(
              userName: newsFeed.userName ?? "",
            ),
            Spacer(),
            MoreButtonView(
              onTapEdit: (){
                onTapEdit(newsFeed.id ?? 0);
              },
              onTapDelete: (){
                onTapDelete(newsFeed.id ?? 0);
              },
            ),
          ],
        ),
        const SizedBox(
          height: MARGIN_MEDIUM_2,
        ),
         Visibility(
           visible: (newsFeed.postImage == null || newsFeed.postImage == "") ? false : true,
           child: PostImageView(
            postImage: newsFeed.postImage ?? "",
                 ),
         ),
        const SizedBox(
          height: MARGIN_MEDIUM_2,
        ),
         PostDescriptionView(
           description: newsFeed.description ?? "",
         ),
        const SizedBox(
          height: MARGIN_MEDIUM_2,
        ),
        Row(
          children: const [
            Text(
              "See Comments",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            Spacer(),
            Icon(
              Icons.mode_comment_outlined,
              color: Colors.grey,
            ),
            SizedBox(
              width: MARGIN_MEDIUM,
            ),
            Icon(
              Icons.favorite_border,
              color: Colors.grey,
            )
          ],
        )
      ],
    );
  }
}

class PostDescriptionView extends StatelessWidget {

  final String description;

  PostDescriptionView({
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
        description,
       //maxLines: 4,
        //overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: TEXT_REGULAR,
        color: Colors.black,
      ),
    );
  }
}

class PostImageView extends StatelessWidget {

  final String postImage;

  PostImageView({
    required this.postImage,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(MARGIN_CARD_MEDIUM_2),
      child: FadeInImage(
        height: 200,
        width: double.infinity,
        placeholder: NetworkImage(
          NETWORK_IMAGE_POST_PLACEHOLDER,
        ),
        image: NetworkImage(
            postImage,
        ),
        fit: BoxFit.fill,
      ),
    );
  }
}

class MoreButtonView extends StatelessWidget {

  final Function onTapDelete;
  final Function onTapEdit;

MoreButtonView({
  required this.onTapDelete,
  required this.onTapEdit,
});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert,color: Colors.grey,),
      itemBuilder: (context) => [
          PopupMenuItem(
            onTap: (){
              onTapEdit();
            },
            child: Text("Edit"),
            value: 1,
            ),
            PopupMenuItem(
              onTap: (){
                onTapDelete();
              },
              child: Text("Delete"),
            value: 2,
            ),
      ]
      );
  }
}

class ProfileImageView extends StatelessWidget {

  final String profileImage;

  ProfileImageView({
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return  CircleAvatar(
      backgroundImage: NetworkImage(profileImage),
      radius: MARGIN_LARGE,
    );
    // print("image =============> $profileImage");
    // return Container(
    //   width: 50,
    //   height: 50,
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(25),
    //   ),
    //   clipBehavior: Clip.antiAlias,
    //   child: Image.network(profileImage,fit: BoxFit.cover,),
    // );
  }
}

class NameLocationAndTimeAgoView extends StatelessWidget {

  final String userName;

  NameLocationAndTimeAgoView({
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              userName,
              style: TextStyle(
                fontSize: TEXT_REGULAR_2X,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: MARGIN_SMALL,
            ),
            Text(
              "- 2 hours ago",
              style: TextStyle(
                fontSize: TEXT_SMALL,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: MARGIN_MEDIUM,
        ),
        const Text(
          "Paris",
          style: TextStyle(
            fontSize: TEXT_SMALL,
            color: Colors.grey,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
