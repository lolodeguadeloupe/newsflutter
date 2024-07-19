import 'package:flutter/material.dart';
import 'package:newsapp/screens/article_details.dart';
import '../models/article.dart';
import '../services/news_services.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  String _selectedCategory = 'general';
  List<Article> _articles = [];

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    try {
      final articles = await NewsService.getArticles(_selectedCategory);
      setState(() {
        _articles = articles;
      });
    } catch (e) {
      print('Erreur lors du chargement des articles: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('News App')),
      body: Column(
        children: [
          _buildCategoryButtons(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadArticles,
              child: _buildArticleList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButtons() {
    final categories = [
      'general',
      'business',
      'technology',
      'sports',
      'entertainment'
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedCategory = category;
                });
                _loadArticles();
              },
              child: Text(category),
            ),
          );
        }).toList(),
      ),
    );
  }


  Widget _buildLoadMoreIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildArticleList() {
    return ListView.builder(
      itemCount: _articles.length,
      itemBuilder: (context, index) {
        final article = _articles[index];
        return Card(
          elevation: 3,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArticleDetailScreen(article: article),
                ),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                  ),
                  child: article.urlToImage.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: article.urlToImage,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        )
                      : Container(
                          width: 120,
                          height: 120,
                          color: Colors.grey[300],
                          child: Icon(Icons.image,
                              size: 40, color: Colors.grey[600]),
                        ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),
                        Text(
                          article.description,
                          style: TextStyle(fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
