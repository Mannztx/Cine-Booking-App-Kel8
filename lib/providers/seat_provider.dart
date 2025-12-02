import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  // METHOD YANG WAJIB ADA (INI YANG BIKIN CHECKOUT BERJALAN)
  Future<void> checkoutToFirebase({
    required BuildContext context,
    required Map<String, dynamic> movie,
  }) async {
    try {
      await FirebaseFirestore.instance.collection("bookings").add({
        "movie_id": movie["id"],
        "movie_title": movie["title"],
        "seats": selectedSeats,
        "time": DateTime.now(),
      });

      clearSeats(); // bersihkan pilihan

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Berhasil checkout kursi!")));

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal checkout: $e")));
    }
  }
}
