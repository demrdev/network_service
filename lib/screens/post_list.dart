import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/network_service.dart';

class PostList extends StatelessWidget {
  final networkService = NetworkService.getInstance();

  Future<List<Post>> fetchPosts() async {
    try {
      final response = await networkService.dio.get('/posts');
      if (response.statusCode == 200) {
        List<Post> posts = (response.data as List).map((postJson) => Post.fromJson(postJson)).toList();
        return posts;
      } else {
        throw Exception('Error fetching posts: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: FutureBuilder<List<Post>>(
        future: fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return ListTile(
                  title: Text(post.title),
                  subtitle: Text(post.body),
                );
              },
            );
          }
        },
      ),
    );
  }
}
