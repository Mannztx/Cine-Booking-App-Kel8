import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel_Firman {
  // Variabel state
  final String bookingId_Firman;
  final String userId_Firman;
  final String movieTitle_Firman;
  final List<String> seats_Firman;
  final int totalPrice_Firman;
  final DateTime bookingDate_Firman;

  BookingModel_Firman({
    required this.bookingId_Firman,
    required this.userId_Firman,
    required this.movieTitle_Firman,
    required this.seats_Firman,
    required this.totalPrice_Firman,
    required this.bookingDate_Firman,
  });

  // Fungsi fromMap (Firebase Map -> Model)
  factory BookingModel_Firman.fromMap_Firman(Map<String, dynamic> map) {
    return BookingModel_Firman(
      bookingId_Firman: map['booking_id'] as String,
      userId_Firman: map['user_id'] as String,
      movieTitle_Firman: map['movie_id'] as String,
      // Array dari firestore dikonversi menjadi list string
      seats_Firman: List<String>.from(map['seats'] as List),
      totalPrice_Firman: map['total_price'] as int,
      // Timestamp dari firestore dikonversi menjadi datetime
      bookingDate_Firman: (map['booking_date'] as Timestamp).toDate(),
    );
  }

  // Fungsi toMap (Model -> Firebase Map)
  Map<String, dynamic> toMap_Firman() {
    return {
      'booking_id': bookingId_Firman,
      'user_id': userId_Firman,
      'movie_title': movieTitle_Firman,
      'seats': seats_Firman,
      'total_price': totalPrice_Firman,
      'booking_date': Timestamp.fromDate(bookingDate_Firman),
    };
  }
}