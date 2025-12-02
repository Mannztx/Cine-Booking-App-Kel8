import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie_model_Firman.dart'; 
import '../models/booking_model_Firman.dart'; 

class MovieController_Maulidin extends ChangeNotifier {
  // --- STATE YANG DIKELOLA ---
  MovieModel_Firman? _selectedMovie_Maulidin;
  final List<String> _selectedSeats_Maulidin = [];
  int _totalPrice_Maulidin = 0;

  // --- GETTERS ---
  MovieModel_Firman? get selectedMovie_Maulidin => _selectedMovie_Maulidin;
  List<String> get selectedSeats_Maulidin => _selectedSeats_Maulidin;
  int get totalPrice_Maulidin => _totalPrice_Maulidin;
  
  // Dipanggil saat Anggota 2 memilih film
  void setSelectedMovie_Maulidin(MovieModel_Firman movie) {
    _selectedMovie_Maulidin = movie;
    _selectedSeats_Maulidin.clear(); 
    calculateTotalPrice_Maulidin();
    notifyListeners(); // Provider
  }

  // Dipanggil saat user mengklik kursi (dari Anggota 3)
  void toggleSeat_Maulidin(String seatName) {
    if (_selectedSeats_Maulidin.contains(seatName)) {
      _selectedSeats_Maulidin.remove(seatName);
    } else {
      _selectedSeats_Maulidin.add(seatName);
    }
    // Setiap perubahan kursi, harga harus dihitung ulang
    calculateTotalPrice_Maulidin(); 
    notifyListeners();
  }

  // Fungsi logic trap
  void calculateTotalPrice_Maulidin() {
    if (_selectedMovie_Maulidin == null || _selectedSeats_Maulidin.isEmpty) {
      _totalPrice_Maulidin = 0;
      notifyListeners();
      return;
    }

    double finalPrice = 0.0;
    final int basePrice = _selectedMovie_Maulidin!.basePrice_Firman;

    // 1. Logic trap untuk movie title lebih dari 10 huruf
    final bool hasLongTitleTax = _selectedMovie_Maulidin!.title_Firman.length > 10;
    final int taxPerSeat = hasLongTitleTax ? 2500 : 0;
    
    for (var seat in _selectedSeats_Maulidin) {
      double seatPrice = basePrice.toDouble();
      int seatNumber;
      // Mengambil bagian angka dari kode kursi ("A1" = 1, "B12" = 12)
      try {
        // Angka dimulai dari karakter kedua (index 1) sampai akhir
        seatNumber = int.parse(seat.substring(1)); 
      } catch (e) {
        seatNumber = 1; // Default ke ganjil/normal jika parsing gagal
      }
      // 2. Logic trap untuk kursi genap kurangi harga total (diskon 10%)
      if (seatNumber % 2 == 0) {
        seatPrice *= 0.90; 
      }
      // Tambahkan Long Title Tax
      seatPrice += taxPerSeat;
      finalPrice += seatPrice;
    }

    _totalPrice_Maulidin = finalPrice.round(); 
    notifyListeners();
  }

  // Fungsi checkout dan simpan database
  // Fungsi ini dipanggil setelah user menekan tombol bayar (dari Anggota 5)
  Future<void> checkout_Maulidin(String userId) async {
    if (_selectedMovie_Maulidin == null || _selectedSeats_Maulidin.isEmpty) {
      // Menambahkan logic error handling jika tidak ada kursi dipilih
      throw Exception('Harap pilih kursi sebelum checkout.');
    }
    
    // Asumsi Anggota 5 sudah memastikan user logged in dan memberikan userId
    final bookingRef = FirebaseFirestore.instance.collection('bookings');
    final newDoc = bookingRef.doc(); // Membuat Document ID unik otomatis

    final newBooking = BookingModel_Firman(
      bookingId_Firman: newDoc.id, // Mengambil Document ID sebagai booking_id
      userId_Firman: userId, 
      movieTitle_Firman: _selectedMovie_Maulidin!.title_Firman,
      seats_Firman: _selectedSeats_Maulidin,
      totalPrice_Firman: _totalPrice_Maulidin,
      bookingDate_Firman: DateTime.now(),
    );

    // Simpan ke Firestore
    await newDoc.set(newBooking.toMap_Firman());

    // Bersihkan state setelah berhasil
    _selectedSeats_Maulidin.clear();
    _totalPrice_Maulidin = 0;
    notifyListeners();
  }
}