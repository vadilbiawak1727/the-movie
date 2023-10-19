class Movie {
  final int id;
  final String title;
  final double voteAverage;
  final String releaseDate;
  final String overview;
  final String posterPath;

  Movie(this.id, this.title, this.voteAverage, this.releaseDate, this.overview, this.posterPath);

  factory Movie.fromJson(Map<String, dynamic> parsedJson) {
    final int id = parsedJson['id'] as int;
    final String title = parsedJson['title'] as String;
    final double voteAverage = parsedJson['vote_average'] + 1.0 as double; 
    final String releaseDate = parsedJson['release_date'] as String;
    final String overview = parsedJson['overview'] as String;
    final String posterPath = parsedJson['poster_path'] as String;

    return Movie(id, title, voteAverage, releaseDate, overview, posterPath);
  }
}
