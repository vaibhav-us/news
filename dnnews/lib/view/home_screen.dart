import 'package:cached_network_image/cached_network_image.dart';
import 'package:dnnews/models/Categories_news_model.dart';
import 'package:dnnews/models/news_channel_headlines_model.dart';
import 'package:dnnews/view/categories_screen.dart';
import 'package:dnnews/view/news_detail_screen.dart';
import 'package:dnnews/view_model/news_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList { bbcNews, cnn }

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  FilterList? selectedMenu;
  String name = 'bbc-news';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CategoriesScreen()));
          },
          icon: Image.asset(
            'images/category_icon.png',
            height: 30,
            width: 30,
          ),
        ),
        title: Text(
          'News',
          style: TextStyle(
            fontFamily: 'Anton',
            fontSize: 24,
          ),
        ),
        actions: [
          PopupMenuButton<FilterList>(
              initialValue: selectedMenu,
              icon: Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              onSelected: (FilterList item) {
                setState(() {
                  selectedMenu = item;
                  name = item == FilterList.bbcNews ? 'bbc-news' : 'cnn-news';
                });
              },
              itemBuilder: (context) => <PopupMenuEntry<FilterList>>[
                    PopupMenuItem<FilterList>(
                      value: FilterList.bbcNews,
                      child: Text('BBC News'),
                    ),
                    PopupMenuItem<FilterList>(
                      value: FilterList.cnn,
                      child: Text('CNN News'),
                    ),
                  ])
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<NewsChannelsHeadlinesModel>(
              future: newsViewModel.fetchNewChannelHeadlinesApi(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: spinkit2,
                  );
                } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.articles == null) {
                  return Center(child: Text("Failed to load news"));
                } else {
                  final articles = snapshot.data!.articles!
                      .where((article) => article.urlToImage != null && article.urlToImage!.isNotEmpty && article.content != null && article.content!.isNotEmpty)
                      .toList();

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      final imageUrl = article.urlToImage!;
                      final title = article.title!;
                      final author = article.author ?? 'Unknown Author';
                      final description = article.description ?? 'No Description';
                      final content = article.content!;
                      DateTime dateTime = DateTime.parse(article.publishedAt ?? DateTime.now().toString());

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewsDetailsScreen(
                                newsImage: imageUrl,
                                newsTitle: title,
                                author: author,
                                description: description,
                                content: content,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: height * 0.45,
                                  width: width * .9,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl: imageUrl,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(child: spinkit2),
                                      errorWidget: (context, url, error) => Icon(Icons.error_outline, color: Colors.red),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  child: Card(
                                    elevation: 5,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Container(
                                      alignment: Alignment.bottomCenter,
                                      height: height * .17,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: width * 0.7,
                                            child: Text(
                                              title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: 'Anton',
                                                fontSize: 30,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
            FutureBuilder<CategoriesNewsModel>(
              future: newsViewModel.fetchCategoriesNewsApi('General'),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: spinkit2,
                  );
                } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.articles == null) {
                  return Center(child: Text("Failed to load category news"));
                } else {
                  final articles = snapshot.data!.articles!
                      .where((article) => article.urlToImage != null && article.urlToImage!.isNotEmpty)
                      .toList();

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      final imageUrl = article.urlToImage!;
                      final title = article.title!;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                height: height * .18,
                                width: width * .3,
                                placeholder: (context, url) => Container(
                                  child: Center(
                                    child: spinkit2,
                                  ),
                                ),
                                errorWidget: (context, url, error) => Icon(Icons.error_outline, color: Colors.red),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: height * .18,
                                padding: EdgeInsets.only(left: 15),
                                child: Column(
                                  children: [
                                    Text(
                                      title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Anton',
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

const spinkit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);
