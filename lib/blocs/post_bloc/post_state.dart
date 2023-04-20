part of 'post_bloc.dart';

abstract class PostState {
  const PostState();
}

class PostInitialState extends PostState {
  final List<Post> posts;
  const PostInitialState({this.posts = const []});
}

class PostValueState extends PostState {
  final List<Post> posts;
  final bool hasReachedMax;
  const PostValueState(this.posts, this.hasReachedMax);
}

class PostFailureState extends PostState {
  final String error;
  const PostFailureState(this.error);
}
