import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/seat_provider.dart';

class SeatPage_Nuris extends StatelessWidget {
  SeatPage_Nuris({super.key});

  @override
  Widget build(BuildContext context) {
    final movie =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(movie["title"]),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
      ),

      // CHECKOUT BUTTON YANG BENAR
      bottomNavigationBar: Consumer<SeatProvider>(
        builder: (context, seatProv, _) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: seatProv.selectedSeats.isEmpty
                  ? null
                  : () async {
                      await seatProv.checkoutToFirebase(
                        context: context,
                        movie: movie,
                      );
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
              child: Text(
                "Checkout (${seatProv.selectedSeats.length} kursi)",
                style: const TextStyle(fontSize: 18),
              ),
            ),
          );
        },
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
          Expanded(child: SeatItem_Nuris(movie: movie)),
        ],
      ),
    );
  }
}

class SeatItem_Nuris extends StatelessWidget {
  final Map<String, dynamic> movie;

  const SeatItem_Nuris({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final seatProv = Provider.of<SeatProvider>(context);

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("bookings").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        final bookings = snapshot.data!.docs;

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 12,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
          ),
          itemCount: 150,
          itemBuilder: (context, index) {
            String kodeKursi = teksKursi_Nuris(index);

            // Kursi yang dipilih
            bool isSelected = seatProv.selectedSeats.contains(kodeKursi);

            // Kursi sudah dibooking user lain
            bool terbooking = bookings.any((b) {
              List kursi = b['seats'];
              return kursi.contains(kodeKursi);
            });

            // Tentukan gambar
            final imagePath = terbooking
                ? 'images/kursi_merah_uas_2.png'
                : (isSelected
                      ? 'images/kursi_biru_uas_2.png'
                      : 'images/kursi_abu_uas_2.png');

            return GestureDetector(
              onTap: () {
                if (!terbooking) {
                  // toggle seat dari provider
                  seatProv.toggleSeat(kodeKursi);
                }
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(imagePath),
                  Text(
                    kodeKursi,
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
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

Widget legendItems_Nuris(String path, String label) {
  return Row(
    children: [
      Image.asset(path, width: 25, height: 25),
      const SizedBox(width: 8),
      Text(label),
    ],
  );
}

String teksKursi_Nuris(int index) {
  List<String> abjad = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
  ];
  int hitung = index ~/ 12;
  int angka = (index % 12) + 1;
  return "${abjad[hitung]}$angka";
}
