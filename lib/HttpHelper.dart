import 'package:http/http.dart' as http;
import 'dart:io';
class HttpHelper {
  final String _urlKey = "?api_key=894efe1565f1f4915ca5642d6a35fc1f";
  final String _urlBase = "https://api.themoviedb.org/";

Future<String> getMovie() async{
  var url = Uri.parse(_urlBase + "3/movie/now_playing?language=en-US&page=1" + _urlKey);
  http.Response result = await http.get(url);
  if (result.statusCode == HttpStatus.ok) {
    String responseBody = result.body;
    return responseBody;
  }
  return result.statusCode.toString();
}
}