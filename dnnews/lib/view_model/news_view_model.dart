

import 'package:dnnews/models/Categories_news_model.dart';
import 'package:dnnews/models/news_channel_headlines_model.dart';
import 'package:dnnews/repositiory/news_repositiory.dart';

class NewsViewModel{

  final _rep = NewsRepositiory();

  Future<NewsChannelsHeadlinesModel> fetchNewChannelHeadlinesApi() async{
     final response = _rep.fetchNewChannelHeadlinesApi();
     return response;
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async{
    final response = _rep.fetchCategoriesNewsApi(category);
    return response;
  }

}