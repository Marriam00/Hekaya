import '../models.dart';
import 'posts_repository.dart';

class MockPostsRepository extends PostsRepository {
  MockPostsRepository({
    required List<Post> posts,
    required List<Comment> comments,
  }) : _posts = List.of(posts),
       _comments = List.of(comments);

  final List<Post> _posts;
  final List<Comment> _comments;

  @override
  List<Post> get posts => List.unmodifiable(_posts);

  @override
  List<Comment> get comments => List.unmodifiable(_comments);

  @override
  List<Comment> commentsFor(String postId) {
    final matching = _comments
        .where((comment) => comment.postId == postId)
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return List.unmodifiable(matching);
  }

  @override
  Future<void> publish(Post post) async {
    _posts.insert(0, post);
    notifyListeners();
  }

  @override
  Future<void> addComment(Comment comment) async {
    if (!_posts.any((post) => post.id == comment.postId)) {
      throw StateError('Post ${comment.postId} does not exist.');
    }
    _comments.add(comment);
    notifyListeners();
  }
}
