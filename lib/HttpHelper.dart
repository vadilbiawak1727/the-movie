import 'package:http/http.dart' as http;

class HttpHelper {
  final String _apiKey = "27bcadec218596d009a17c5ffab8d387";
  final String _baseUrl = "https://api.themoviedb.org/3/movie";

  Future<String> getMoviesByCategory(String category) async {
    final String url = '$_baseUrl/$category?api_key=$_apiKey';
    final http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return 'Failed to fetch data';
    }
  }
}
