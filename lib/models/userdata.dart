import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserData with ChangeNotifier {
  List<Article> newsData = [];
  List<Article> searchResult = [];
  String? makeString(String? s) {
    if (s == null) {
      return null;
    }

    return s.replaceAll(' ', '-');
  }

  Future<void> loadData() async {
    String url =
        'https://newsapi.org/v2/top-headlines?country=in&apiKey=4ba8f87a89a34ab18639ea6c771bb244';
    final response = await http.get(Uri.parse(url));
    News news = newsFromJson(response.body);
    newsData = List<Article>.from(news.articles);
    print(newsData[0].title);
    notifyListeners();
  }

  Future<void> searchNews(String query) async {
    String url =
        'https://newsapi.org/v2/everything?q=${makeString(query)}&sortBy=popularity&apiKey=4ba8f87a89a34ab18639ea6c771bb244';
    final response = await http.get(Uri.parse(url));
    News news = newsFromJson(response.body);
    searchResult = List<Article>.from(news.articles);
    print(newsData[0].title);
    notifyListeners();
  }
}

// To parse this JSON data, do
//
//     final news = newsFromJson(jsonString);

News newsFromJson(String str) => News.fromJson(json.decode(str));

String newsToJson(News data) => json.encode(data.toJson());

class News {
  News({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  String status;
  int totalResults;
  List<Article> articles;

  factory News.fromJson(Map<String, dynamic> json) => News(
        status: json["status"],
        totalResults: json["totalResults"],
        articles: List<Article>.from(
            json["articles"].map((x) => Article.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "totalResults": totalResults,
        "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
      };
}

class Article {
  Article({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  Source? source;
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  DateTime? publishedAt;
  String? content;

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        source: Source.fromJson(json["source"]),
        author: json["author"],
        title: json["title"],
        description: json["description"],
        url: json["url"],
        urlToImage: json["urlToImage"],
        publishedAt: DateTime.parse(json["publishedAt"]),
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "source": source?.toJson(),
        "author": author,
        "title": title,
        "description": description,
        "url": url,
        "urlToImage": urlToImage,
        "publishedAt": publishedAt?.toIso8601String(),
        "content": content,
      };
}

class Source {
  Source({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory Source.fromJson(Map<String, dynamic> json) => Source(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
