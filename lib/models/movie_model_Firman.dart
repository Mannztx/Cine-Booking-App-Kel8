class MovieModel_Firman {
  // Variabel state
  final String movieId_Firman;
  final String title_Firman;
  final String posterUrl_Firman;
  final int basePrice_Firman;
  final double rating_Firman;
  final int duration_Firman;

  MovieModel_Firman({
    required this.movieId_Firman,
    required this.title_Firman,
    required this.posterUrl_Firman,
    required this.basePrice_Firman,
    required this.rating_Firman,
    required this.duration_Firman,
  });

  // Fungsi fromMap (Firebase Map -> Model)
  factory MovieModel_Firman.fromMap_Firman(Map<String, dynamic> map) {
    return MovieModel_Firman(
      movieId_Firman: map['movie_id'] as String,
      title_Firman: map['title'] as String,
      posterUrl_Firman: map['poster_url'] as String,
      basePrice_Firman: map['base_price'] as int,
      rating_Firman: map['rating'] as double,
      duration_Firman: map['duration'] as int,
    );
  }

  // Fungsi toMap (Model -> Firebase Map)
  Map<String, dynamic> toMap_Firman() {
    return {
      'movie_id': movieId_Firman,
      'title': title_Firman,
      'poster_url': posterUrl_Firman,
      'base_price': basePrice_Firman,
      'rating': rating_Firman,
      'duration': duration_Firman,
    };
  }
}
