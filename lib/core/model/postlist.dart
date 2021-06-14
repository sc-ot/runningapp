import 'package:bestpractice/core/model/post.dart';
import 'package:json_annotation/json_annotation.dart';

part 'postlist.g.dart';

@JsonSerializable()
class PostList {
  PostList(this.posts);
 
 factory PostList.fromJson(Map<String, dynamic> json) => _$PostListFromJson(json);
 Map<String, dynamic> toJson() => _$PostListToJson(this);

  late List<Post> posts;
}
