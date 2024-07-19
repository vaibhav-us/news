import 'dart:convert';

import 'package:dnnews/models/Categories_news_model.dart';
import 'package:dnnews/models/news_channel_headlines_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NewsRepositiory {

  Future<NewsChannelsHeadlinesModel> fetchNewChannelHeadlinesApi()async{
    String url='https://newsapi.org/v2/top-headlines?country=in&apiKey=ec047e14c61c458493637b4e6cd62c51';

    final response = await http.get(Uri.parse(url));
    if(kDebugMode){
      print(response.body);
    }
    if(response.statusCode==200){
      final body = jsonDecode(response.body);
      return NewsChannelsHeadlinesModel.fromJson(body);

    }
    throw Exception('Error');
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category)async{
    String url='https://newsapi.org/v2/everything?q=$category&apiKey=ec047e14c61c458493637b4e6cd62c51';
    final response = await http.get(Uri.parse(url));
    if(kDebugMode){
      print(response.body);
    }
    if(response.statusCode==200){
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);

    }
    throw Exception('Error');
  }
}