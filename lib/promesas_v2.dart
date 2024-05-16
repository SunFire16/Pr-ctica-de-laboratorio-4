import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:examen_application_1/types/post.dart';

void main(List<String> arguments) async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NewsScreen(),
    );
  }
}

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  Future<List<Post>> fetchNews() async {
    var url = Uri.https('newsapi.org', '/v2/top-headlines', {
      'country': 'us',
      'category': 'business',
      'apiKey': '6b0ff806eab742408a4001c605d30f72',
    });

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return postFromJson(response.body);
    } else {
      throw Exception('Error al cargar las noticias');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Top Business News')),
      body: FutureBuilder<List<Post>>(
        future: fetchNews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading news'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No news available'));
          } else {
            final news = snapshot.data!;
            return ListView.builder(
              itemCount: news.length,
              itemBuilder: (context, index) {
                final post = news[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(post.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(post.description ?? ''),
                          Text('Author: ${post.author ?? 'Unknown'}'),
                          Text('Published At: ${post.publishedAt}'),
                          Text('Source: ${post.source.name}'),
                          Text('URL: ${post.url}'),
                          if (post.urlToImage != null)
                            Image.network(post.urlToImage!),
                          Text('Content: ${post.content ?? 'No content available'}'),
                        ],
                      ),
                      onTap: () {
                      },
                    ),
                    Divider(),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
