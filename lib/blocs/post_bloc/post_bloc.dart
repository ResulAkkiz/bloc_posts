import 'dart:developer';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:bloc_posts/model/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

import '../../service/post_api_client.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostApiClient apiClient = PostApiClient();
  PostBloc() : super(const PostInitialState()) {
    on<PostFetchEvent>(
      (event, emit) async {
        try {
          if (state is PostInitialState) {
            log('state is PostInitialState');
            List<Post> posts = await apiClient.fetchPost();
            emit(PostValueState(posts, false));
          }
          if (state is PostValueState) {
            log('state is PostValueState');
            final PostValueState currentState = state as PostValueState;
            if (currentState.hasReachedMax) return;
            log('state is\'not PostValueState hasReachedMax');
            List<Post> posts =
                await apiClient.fetchPost(currentState.posts.length);
            posts.isEmpty
                ? emit(PostValueState(currentState.posts, true))
                : emit(
                    PostValueState([...currentState.posts, ...posts], false));
          }
        } on PlatformException catch (e) {
          log('state is PostFailureState');
          emit(PostFailureState(e.message ?? ''));
        }
      },
      transformer: droppable(),
    );
  }
}
