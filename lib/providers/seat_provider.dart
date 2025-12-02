import 'package:flutter/material.dart';

class SeatProvider extends ChangeNotifier {
  List<String> selectedSeats = [];

  void toggleSeat(String seatCode) {
    if (selectedSeats.contains(seatCode)) {
      selectedSeats.remove(seatCode);
    } else {
      selectedSeats.add(seatCode);
    }
    notifyListeners();
  }

  void clearSeats() {
    selectedSeats.clear();
    notifyListeners();
  }
}
