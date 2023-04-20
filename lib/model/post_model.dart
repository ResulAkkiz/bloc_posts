// ignore_for_file: public_member_api_docs, sort_constructors_first
class Post {
  int id;
  String title;
  String body;
  Post({
    required this.id,
    required this.title,
    required this.body,
  });

  Post.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        body = json['body'];

  Post copyWith({
    int? id,
    String? title,
    String? body,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }
}
