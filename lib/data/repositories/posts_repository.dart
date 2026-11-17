import 'package:flutter/foundation.dart';

import '../models.dart';

abstract class PostsRepository extends ChangeNotifier {
  List<Post> get posts;
  List<Comment> get comments;

  List<Comment> commentsFor(String postId);
  Future<void> publish(Post post);
  Future<void> addComment(Comment comment);
}
