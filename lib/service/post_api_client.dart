import 'dart:convert';

import 'package:bloc_posts/model/post_model.dart';
import 'package:http/http.dart';

final Client _client = Client();
const int _limit = 15;

class PostApiClient {
  Future<List<Post>> fetchPost([int startIndex = 0]) async {
    Response response = await _client.get(Uri.https(
        'jsonplaceholder.typicode.com',
        '/posts',
        {'_start': startIndex.toString(), '_limit': _limit.toString()}));

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List<dynamic>)
          .map((singleMap) => Post.fromJson(Map.from(singleMap)))
          .toList();
    } else {
      throw Exception(response.body);
    }
  }
}
