import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/seat_provider_dinn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cine_booking_app_kel8/controllers/booking_logic_controller_dinn.dart';

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

          Consumer<SeatProvider_dinn>(
            builder: (context, seatProv, _) {
              final logic = BookingLogicController_dinn();
              final movie =
                  ModalRoute.of(context)!.settings.arguments
                      as Map<String, dynamic>;

              double totalPrice = logic.calculateTotal_dinn(
                movieTitle_dinn: movie["title"],
                seats_dinn: seatProv.selectedSeats,
                basePrice_dinn: movie["base_price"].toDouble(),
              );

              return _buildCheckoutArea_Nuris(
                context,
                seatProv.selectedSeats,
                totalPrice,
              );
            },
          ),
        ],
      ),
    );
  }
}

class SeatItem_Nuris extends StatelessWidget {
  final Map<String, dynamic> movie;

  SeatItem_Nuris({required this.movie});
  @override
  Widget build(BuildContext context) {
    final seatProv = Provider.of<SeatProvider_dinn>(context);

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("bookings")
          .where("movie_title", isEqualTo: movie["title"])
          .snapshots(),
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

            bool isSelected = seatProv.selectedSeats.contains(kodeKursi);

            bool terbooking = bookings.any((b) {
              List kursi = b['seats'];
              return kursi.contains(kodeKursi);
            });

            final imagePath = terbooking
                ? 'images/kursi_merah_uas_2.png'
                : (isSelected
                      ? 'images/kursi_biru_uas_2.png'
                      : 'images/kursi_abu_uas_2.png');

            return GestureDetector(
              onTap: () {
                if (!terbooking) {
                  seatProv.toggleSeat_dinn(kodeKursi);
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

Widget _buildCheckoutArea_Nuris(
  BuildContext context,
  List<String> kursiDipilih,
  double hargaTiket,
) {
  final seatProv = Provider.of<SeatProvider_dinn>(context, listen: false);
  final movie =
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  final logic = BookingLogicController_dinn();
  double totalPrice = logic.calculateTotal_dinn(
    movieTitle_dinn: movie["title"],
    seats_dinn: seatProv.selectedSeats,
    basePrice_dinn: movie["base_price"].toDouble(),
  );

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
            const Text("Total Harga:"),
            Text(
              "Rp ${totalPrice.toInt()}",
              style: const TextStyle(
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
            onPressed: kursiDipilih.isEmpty
                ? null
                : () async {
                    await seatProv.checkoutToFirebase_dinn(
                      context: context,
                      movie: movie,
                      userId: FirebaseAuth.instance.currentUser!.uid,
                    );
                  },
            icon: const Icon(Icons.confirmation_number, color: Colors.white),
            label: const Text("Book Ticket"),
          ),
        ),
      ],
    ),
  );
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
