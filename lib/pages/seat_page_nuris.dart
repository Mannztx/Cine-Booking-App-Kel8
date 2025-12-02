import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// Import Model dan Controller yang dibuat oleh anggota lain
import '../models/movie_model_Firman.dart'; 
import '../controllers/movie_controller_Maulidin.dart'; 

class SeatPage_Nuris extends StatelessWidget {
  const SeatPage_Nuris({super.key});
  
  @override
  Widget build(BuildContext context) {
  // 1. Ambil Controller Maulidin
    final movieController = context.watch<MovieController_Maulidin>();
 
    // 2. Ambil Movie Model yang sudah diset Anggota 2
    final MovieModel_Firman? selectedMovie = movieController.selectedMovie_Maulidin;

    if (selectedMovie == null) {
      // Jika null, langsung tampilkan halaman error dan keluar dari fungsi build
      return Scaffold(
        appBar: AppBar(title: Text("Pilih Film Dulu")),
        body: Center(child: Text("Film belum dipilih.")),
      );
    }

    // Setelah melewati blok if, selectedMovie dijamin TIDAK NULL
    final int totalPrice = movieController.totalPrice_Maulidin;

    return Scaffold(
      appBar: AppBar(
        // KOREKSI: Gunakan ! karena sudah dipastikan selectedMovie tidak null
        title: Text(selectedMovie.title_Firman), 
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          }, 
          icon: const Icon(Icons.arrow_back)
        ),
      ),
      body: Column(
        children: [
          Divider(
            thickness: 1,
            color: Colors.grey[300],
          ),
          // --- Legenda Kursi ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              legendItems_Nuris('images/kursi_abu_uas_2.png', "Kosong"),
              legendItems_Nuris('images/kursi_biru_uas_2.png', "Dipilih"),
              legendItems_Nuris('images/kursi_merah_uas_2.png', "Terjual"),
            ],
          ),
          Divider(
            thickness: 1,
            color: Colors.grey[300],
          ),
          // --- Grid Kursi ---
          Expanded(child: _buildSeatGrid(context, movieController)),

          // --- Tombol Checkout ---
          _buildCheckoutArea_Nuris(context, movieController, totalPrice),
        ],
      )
    );
  }
}

// Widget untuk Area Kursi (menggantikan SeatItem_Nuris class lama)
Widget _buildSeatGrid(BuildContext context, MovieController_Maulidin controller) {
  final selectedSeats = controller.selectedSeats_Maulidin;
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection("bookings").snapshots(), 
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (!snapshot.hasData) return const Center(child: Text("Tidak ada data pemesanan."));
      final bookings = snapshot.data!.docs;

      final Set<String> allBookedSeats = {};
      for (var doc in bookings) {
        // Logika untuk mengambil data 'seats' yang sudah terjual
        if (doc.data() != null) {
          final data = doc.data() as Map<String, dynamic>;
          // Pastikan menggunakan field name yang benar sesuai database: 'seats'
          if (data.containsKey('seats') && data['seats'] is List) {
            allBookedSeats.addAll(List<String>.from(data['seats']));
          }
        }
      }
      return GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 12, 
          mainAxisSpacing: 5,
          crossAxisSpacing: 5
        ),
        itemCount: 150, 
        itemBuilder: (context, index) {
          String kodeKursi = teksKursi_Nuris(index);
          bool isBooked = allBookedSeats.contains(kodeKursi); 
          bool isSelected = selectedSeats.contains(kodeKursi); 
          final String imagePath;
          if (isBooked) {
            imagePath = 'images/kursi_merah_uas_2.png';
          } else if (isSelected) {
            imagePath = 'images/kursi_biru_uas_2.png';
          } else {
            imagePath = 'images/kursi_abu_uas_2.png';
          }
          return GestureDetector(
            onTap: isBooked ? null : () { 
              // Panggil toggleSeat_Maulidin di Controller Maulidin
              context.read<MovieController_Maulidin>().toggleSeat_Maulidin(kodeKursi);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  imagePath,
                ),
                Text(kodeKursi,
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold, 
                    ),
                  ) 
                ),
              ],
            )
          );
        },
      );
    }
  );
 }

// Widget terpisah untuk area checkout
Widget _buildCheckoutArea_Nuris(BuildContext context, MovieController_Maulidin controller, int totalPrice) {
  // Anggota 5 akan menyediakan userId yang sebenarnya
  const String dummyUserId = "ULqHXlIx...AcV73"; 
  
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 5,
          offset: const Offset(0, -2),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Tampilan Harga Total
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total Harga:",
              style: GoogleFonts.roboto(fontSize: 14, color: Colors.grey),
            ),
            Text(
              // Format harga dengan titik (separator)
              "Rp ${totalPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
              style: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
          ],
        ),

        // Tombol Checkout
        SizedBox(
          width: 180,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: controller.selectedSeats_Maulidin.isEmpty ? null : () async {
              try {
                // Panggil fungsi checkout Anggota 4
                await controller.checkout_Maulidin(dummyUserId); 
                // Feedback berhasil
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Pemesanan berhasil!"))
                  );
                  // Kembali ke halaman home (asumsi halaman awal adalah home)
                  Navigator.popUntil(context, (route) => route.isFirst);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error Checkout: ${e.toString()}"))
                  );
                }
              }
            },
            icon: const Icon(Icons.confirmation_number, color: Colors.white),
            label: Text("Book Ticket", style: GoogleFonts.roboto(fontSize: 18, color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo, // Warna tombol (sesuai tema)
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ],
    ),
  );
}

// Widget legendItems dan teksKursi_Nuris tetap sama
Widget legendItems_Nuris(String path, String label) {
  return Row(
    children: [
      Image.asset(path,
      width: 25,
      height:25,),
      const SizedBox(width: 8),
      Text(label),
    ],
  );
}

String teksKursi_Nuris(int index){
  List<String> abjad = ['A', 'B', 'C', 'D', 'E','F', 'G', 'H', 'I', 'J','K','L','M', 'N', 'O', 'P'];
  int hitung = index ~/ 12; 
  int angka = (index % 12) + 1; 

  if (hitung >= abjad.length) return ''; 

  return "${abjad[hitung]}$angka";
}