class BookingLogicController {
  double tax = 2500;

  double calculateTotal({
    required String movieTitle,
    required double basePrice,
    required List<String> seats,
  }) {
    double total = seats.length * basePrice;
    double kursiGenap = basePrice + tax;

    double hargaPerKursi() {
      if (movieTitle.length > 10) {
        return kursiGenap;
      } else {
        return basePrice;
      }
    }

    if (movieTitle.length > 10) {
      total += tax * seats.length;
    }

    for (String seat in seats) {
      final number = int.tryParse(seat.substring(1));
      if (number != null && number % 2 == 0) {
        total -= hargaPerKursi() * 0.10;
      }
    }

    return total;
  }
}
