import 'package:flutter/material.dart';

import 'httpHelper.dart';

class Screen1 extends StatefulWidget {
  const Screen1({Key? key}) : super(key: key);

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
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
          // Ubah dropdown menu menjadi radio button
          Column(
            children: [
              RadioListTile<String>(
                value: 'latest',
                title: Text('Latest'),
                groupValue: selectedCategory,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                    fetchMovies(newValue);
                  }
                },
              ),
              RadioListTile<String>(
                value: 'now_playing',
                title: Text('Now Playing'),
                groupValue: selectedCategory,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                    fetchMovies(newValue);
                  }
                },
              ),
              RadioListTile<String>(
                value: 'popular',
                title: Text('Popular'),
                groupValue: selectedCategory,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                    fetchMovies(newValue);
                  }
                },
              ),
              RadioListTile<String>(
                value: 'top_rated',
                title: Text('Top Rated'),
                groupValue: selectedCategory,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                    fetchMovies(newValue);
                  }
                },
              ),
              RadioListTile<String>(
                value: 'upcoming',
                title: Text('Upcoming'),
                groupValue: selectedCategory,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                    fetchMovies(newValue);
                  }
                },
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Text("$result"),
            ),
          ),
        ],
      ),
    );
  }
}
