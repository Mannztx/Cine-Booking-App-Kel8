import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cine_booking_app_kel8/controllers/booking_logic_controller_dinn.dart';

class SeatProvider_dinn extends ChangeNotifier {
  List<String> selectedSeats = [];

  void toggleSeat_dinn(String seatCode) {
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
  Future<void> checkoutToFirebase_dinn({
    required BuildContext context,
    required Map<String, dynamic> movie,
    required String userId,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final logic = BookingLogicController_dinn();
    double totalPrice = logic.calculateTotal_dinn(
      movieTitle_dinn: movie["title"],
      seats_dinn: selectedSeats,
      basePrice_dinn: movie["base_price"].toDouble(),
    );

    try {
      final docRef = await FirebaseFirestore.instance.collection("bookings").add({
        "movie_title": movie["title"],
        "total_price": totalPrice.toInt(),
        "seats": selectedSeats,
        "booking_date": DateTime.now(),
        "user_id": uid,
      });
      final bookingId = docRef.id;
      await docRef.update({
        "booking_id": bookingId,
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
