import 'package:cloud_firestore/cloud_firestore.dart';

class BookingLogicController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  double basePrice = 35000; // harga dasar 1 kursi
  double tax = 5000; // tax tambahan jika judul > 10 karakter

  /// ====================================================
  /// 1. TRAP 1: Cek panjang judul film
  /// ====================================================
  double applyTitleTrap(String movieTitle) {
    if (movieTitle.length > 10) {
      return tax;
    }
    return 0;
  }

  /// ====================================================
  /// 2. TRAP 2: Cek setiap seat
  /// A2 → ambil angka "2" → jika angka GENAP → diskon
  /// ====================================================
  double applySeatTrap(List<String> seats) {
    double totalDiscount = 0;

    for (String seat in seats) {
      // contoh seat "A2" → ambil karakter ke-1
      final number = int.tryParse(seat.substring(1));

      if (number != null && number % 2 == 0) {
        totalDiscount += 3000; // diskon kursi genap
      }
    }
    return totalDiscount;
  }

  /// ====================================================
  /// 3. Hitung total harga final
  /// ====================================================
  double calculateTotal(String movieTitle, List<String> seats) {
    double total = seats.length * basePrice;

    double taxValue = applyTitleTrap(movieTitle);
    double seatDiscount = applySeatTrap(seats);

    total = total + taxValue - seatDiscount;

    return total;
  }

  /// ====================================================
  /// 4. Checkout → kirim data ke Firebase
  /// ====================================================
  Future<void> checkout({
    required String movieId,
    required String movieTitle,
    required String userId,
    required List<String> seats,
  }) async {
    double totalPrice = calculateTotal(movieTitle, seats);

    await _db.collection("bookings").add({
      "movieId": movieId,
      "movieTitle": movieTitle,
      "userId": userId,
      "seats": seats,
      "total": totalPrice,
      "timestamp": DateTime.now().toIso8601String(),
    });
  }
}
