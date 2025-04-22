import 'package:flutter_application_1/models/post.dart';
import 'package:flutter_application_1/utils/http.dart';

Future<List<Post>> getPosts() async {
  final res = await Request.get('https://jsonplaceholder.typicode.com/posts');
  return (res.data as List)
      .map((e) => Post.fromMap(e as Map<String, dynamic>))
      .toList();
}
