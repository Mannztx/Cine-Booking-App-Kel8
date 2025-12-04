class BookingLogicController_dinn {
  double tax = 2500;

  double calculateTotal_dinn({
    required String movieTitle_dinn,
    required double basePrice_dinn,
    required List<String> seats_dinn,
  }) {
    double total = seats_dinn.length * basePrice_dinn;
    double kursiGenap = basePrice_dinn + tax;

    double hargaPerKursi() {
      if (movieTitle_dinn.length > 10) {
        return kursiGenap;
      } else {
        return basePrice_dinn;
      }
    }

    if (movieTitle_dinn.length > 10) {
      total += tax * seats_dinn.length;
    }

    for (String seat in seats_dinn) {
      final number = int.tryParse(seat.substring(1));
      if (number != null && number % 2 == 0) {
        total -= hargaPerKursi() * 0.10;
      }
    }

    return total;
  }
}