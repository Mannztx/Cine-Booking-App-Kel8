import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/movie_model_Firman.dart';
import '../controllers/movie_controller_Maulidin.dart';

class SeatPage_Nuris extends StatelessWidget {
  const SeatPage_Nuris({super.key});

  @override
  Widget build(BuildContext context) {
    final movieController = context.watch<MovieController_Maulidin>();
    final MovieModel_Firman? selectedMovie = movieController.selectedMovie_Maulidin;

    if (selectedMovie == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Pilih Film Dulu")),
        body: const Center(child: Text("Film belum dipilih.")),
      );
    }

    final int totalPrice = movieController.totalPrice_Maulidin;

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedMovie.title_Firman),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          Divider(thickness: 1, color: Colors.grey[300]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              legendItems_Nuris('images/kursi_abu_uas_2.png', "Kosong"),
              legendItems_Nuris('images/kursi_biru_uas_2.png', "Dipilih"),
              legendItems_Nuris('images/kursi_merah_uas_2.png', "Terjual"),
            ],
          ),
          Divider(thickness: 1, color: Colors.grey[300]),

          const Expanded(child: SeatItem_Nuris()),

          _buildCheckoutArea(context, movieController, totalPrice),
        ],
      ),
    );
  }
}


class SeatItem_Nuris extends StatefulWidget {
  const SeatItem_Nuris({super.key});

  @override
  State<SeatItem_Nuris> createState() => _SeatItemNurisState();
}

class _SeatItemNurisState extends State<SeatItem_Nuris> {
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MovieController_Maulidin>();
    final selectedSeats = controller.selectedSeats_Maulidin;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("bookings").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final bookings = snapshot.data!.docs;

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 12,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
          ),
          itemCount: 150,
          itemBuilder: (context, index) {
            String kodeKursi = teksKursi_Nuris(index);

            bool dipilih = selectedSeats.contains(kodeKursi);

            bool terbooking = bookings.any((b) {
              List kursi = b['seats'];
              return kursi.contains(kodeKursi);
            });

            final String imagePath;
            if (terbooking) {
              imagePath = 'images/kursi_merah_uas_2.png';
            } else if (dipilih) {
              imagePath = 'images/kursi_biru_uas_2.png';
            } else {
              imagePath = 'images/kursi_abu_uas_2.png';
            }

            return GestureDetector(
              onTap: terbooking
                  ? null
                  : () {
                      controller.toggleSeat_Maulidin(kodeKursi);
                    },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(imagePath),
                  Text(
                    kodeKursi,
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}


Widget _buildCheckoutArea(
  BuildContext context,
  MovieController_Maulidin controller,
  int totalPrice,
) {
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Total Harga:", style: GoogleFonts.roboto(fontSize: 14, color: Colors.grey)),
            Text(
              "Rp ${totalPrice.toString()}",
              style: GoogleFonts.roboto(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
          ],
        ),
        SizedBox(
          width: 180,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: controller.selectedSeats_Maulidin.isEmpty
                ? null
                : () async {
                    await controller.checkout_Maulidin(dummyUserId);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Pemesanan berhasil!")));
                      Navigator.popUntil(context, (route) => route.isFirst);
                    }
                  },
            icon: const Icon(Icons.confirmation_number, color: Colors.white),
            label: Text("Book Ticket",
                style: GoogleFonts.roboto(fontSize: 18, color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ],
    ),
  );
}


Widget legendItems_Nuris(String path, String label) {
  return Row(
    children: [
      Image.asset(path, 
      width: 25, 
      height: 25),
      const SizedBox(width: 8),
      Text(label),
    ],
  );
}

String teksKursi_Nuris(int index) {
  List<String> abjad = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I','J', 'K', 'L', 'M', 'N', 'O', 'P'];
  int hitung = index ~/ 12;
  int angka = (index % 12) + 1;
  return "${abjad[hitung]}$angka";
}