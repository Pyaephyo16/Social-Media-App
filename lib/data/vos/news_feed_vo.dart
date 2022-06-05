import 'package:json_annotation/json_annotation.dart';

part 'news_feed_vo.g.dart';

@JsonSerializable()
class NewsFeedVO{

  @JsonKey(name: "id")
    int? id;

  @JsonKey(name: "description")
    String? description;

  @JsonKey(name: "profile_image")
    String? profilePicture;

  @JsonKey(name: "user_name")
    String? userName;

  @JsonKey(name: "post_image")
    String? postImage;

  NewsFeedVO.empty();

  NewsFeedVO(this.id, this.description, this.profilePicture, this.userName,
      this.postImage);

  factory NewsFeedVO.fromJson(Map<String,dynamic> json) => _$NewsFeedVOFromJson(json);

  Map<String,dynamic> toJson() => _$NewsFeedVOToJson(this);

  @override
  String toString() {
    return 'NewsFeedVO{id: $id, description: $description, profilePicture: $profilePicture, userName: $userName, postImage: $postImage}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewsFeedVO &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          description == other.description &&
          profilePicture == other.profilePicture &&
          userName == other.userName &&
          postImage == other.postImage;

  @override
  int get hashCode =>
      id.hashCode ^
      description.hashCode ^
      profilePicture.hashCode ^
      userName.hashCode ^
      postImage.hashCode;
}