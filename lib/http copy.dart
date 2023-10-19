import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:the_movie/HttpHelper.dart';

class Screen1 extends StatefulWidget {
  const Screen1({Key? key}) : super(key: key);

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  late List<dynamic> movies;
  late String result;
  late HttpHelper helper;
  String selectedCategory = 'now_playing';

  @override
  void initState() {
    super.initState();
    helper = HttpHelper();
    result = "";

    fetchMovies(selectedCategory);
  }

  Future<void> fetchMovies(String category) async {
    final String movieData = await helper.getMoviesByCategory(category);
    setState(() {
      result = movieData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Movie'),
        backgroundColor: Color.fromARGB(255, 46, 217, 255),
      ),
      body: Column(
        children: <Widget>[
          // DropdownButton
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedCategory,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedCategory = newValue;
                    fetchMovies(newValue);
                  });
                }
              },
              items: const [
                DropdownMenuItem<String>(
                  value: 'latest',
                  child: Text('Latest'),
                ),
                DropdownMenuItem<String>(
                  value: 'now_playing',
                  child: Text('Now Playing'),
                ),
                DropdownMenuItem<String>(
                  value: 'popular',
                  child: Text('Popular'),
                ),
                DropdownMenuItem<String>(
                  value: 'top_rated',
                  child: Text('Top Rated'),
                ),
                DropdownMenuItem<String>(
                  value: 'upcoming',
                  child: Text('Upcoming'),
                ),
              ],
            ),
          ),
          // Expanded untuk memenuhi ruang yang tersisa
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (var movie in json.decode(result)["results"])
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg",
                            width: 100,
                            height: 150,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(), // Placeholder loading
                            errorWidget: (context, url, error) => Icon(
                                Icons.error), // Placeholder jika gagal muat
                          ),
                        ),
                        Text(movie["title"]),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
