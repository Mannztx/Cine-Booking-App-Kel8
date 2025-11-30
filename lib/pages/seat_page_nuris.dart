import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SeatPage_Nuris extends StatelessWidget {
  // final QueryDocumentSnapshot movie;

  SeatPage_Nuris({super.key});

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
          Expanded(child: SeatItem_Nuris(),)
          
        ],
      )

    );
  }
}

class SeatItem_Nuris extends StatefulWidget {
  const SeatItem_Nuris({super.key});

  @override
  State<SeatItem_Nuris> createState() => _SeatItem_state_Nuris();
}

class _SeatItem_state_Nuris extends State<SeatItem_Nuris>{

 final List<int> kursiPilihan = [];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("bookings").snapshots(), 
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        final docs = snapshot.data!.docs;
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 12,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5
          ),

          itemCount: 150,
          itemBuilder: (context, index) {
            bool isPressed = kursiPilihan.contains(index);
            final String imagePath = isPressed
              ?'images/kursi_biru_uas_2.png'
              :'images/kursi_abu_uas_2.png';
                  // final m = docs[index];
            return GestureDetector(
              onTap: (){
                setState(() {
                  if (isPressed) {
                    kursiPilihan.remove(index);
                  } 
                  else {
                    kursiPilihan.add(index);
                  }
                });
              },

              child:Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    imagePath,
                  ),
                  Text(teksKursi_Nuris(index),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
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