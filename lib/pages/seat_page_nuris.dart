import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class SeatPage_Nuris extends StatelessWidget {
  SeatPage_Nuris({super.key});
  final ValueNotifier<List<String>> kursiPilihanNotifier = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    final movie = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: Text(movie["title"]),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          }, 
          icon: Icon(Icons.arrow_back)
        ),
      ),
      body: Column(
        children: [
          Divider(
            thickness: 1,        
            color: Colors.grey[300],  
          ),
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
          Expanded(child: 
            SeatItem_Nuris(
              onSeatChanged: (kursi) {
                kursiPilihanNotifier.value = List.from(kursi);
              },
            ),
          ),
          ValueListenableBuilder(
            valueListenable: kursiPilihanNotifier,
            builder: (context, kursiDipilih, _) {
              return _buildCheckoutArea_Nuris(context, kursiDipilih, 35000);
            },
          ),
        ],
      )
    );
  }
}

class SeatItem_Nuris extends StatefulWidget {
   final Function(List<String>) onSeatChanged;
  const SeatItem_Nuris({super.key, required this.onSeatChanged});

  @override
  State<SeatItem_Nuris> createState() => _SeatItem_state_Nuris();
}

class _SeatItem_state_Nuris extends State<SeatItem_Nuris>{

 final List<String> kursiPilihan = [];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("bookings").snapshots(), 
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        final bookings = snapshot.data!.docs;
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 12,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5
          ),

          itemCount: 150,
          itemBuilder: (context, index) {
            String kodeKursi = teksKursi_Nuris(index);
            bool diPilih = kursiPilihan.contains(kodeKursi);

            final terbooking = bookings.any((b) {
              List kursi = b['seats'];
              return kursi.contains(kodeKursi);
            });

            final String imagePath;

            if (terbooking) {
              imagePath = 'images/kursi_merah_uas_2.png';  
            } else if(diPilih){
              imagePath = 'images/kursi_biru_uas_2.png';
            } else{
              imagePath = 'images/kursi_abu_uas_2.png';
            }

            return GestureDetector(
              onTap: (){
                setState(() {
                  if (diPilih) {
                    kursiPilihan.remove(kodeKursi);
                  } 
                  else {
                    kursiPilihan.add(kodeKursi);
                  }
                  widget.onSeatChanged(kursiPilihan);
                });
              },

              child:Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    imagePath,
                  ),
                  Text(teksKursi_Nuris(index),
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
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
}


Widget _buildCheckoutArea_Nuris(
  BuildContext context,
  List<String> kursiDipilih,
  int hargaTiket,
) {
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
              "Rp ${(kursiDipilih.length * hargaTiket)}",
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
                    await FirebaseFirestore.instance
                        .collection("bookings")
                        .add({
                      "seats": kursiDipilih,
                      "timestamp": DateTime.now(),
                    });

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Pemesanan Berhasil!"),
                        ),
                      );

                      Navigator.popUntil(context, (route) => route.isFirst);
                    }
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
  int angka = (index%12)+1;
  return "${abjad[hitung]}$angka";
}