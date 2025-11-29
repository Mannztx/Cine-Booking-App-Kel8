import 'package:flutter/material.dart';

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
              legendItem('images/kursi_abu_uas.png', "Kosong"),
              legendItem('images/kursi_biru_uas.png', "Dipilih"),
              legendItem('images/kursi_merah_uas.png', "Terjual"),
            ],
          ),
          Divider(
            thickness: 1,        
            color: Colors.grey[300],  
          ),
          SeatItem_Nuris()
        ],
      )

    );
  }
}

class SeatItem_Nuris extends StatefulWidget {
  const SeatItem_Nuris({super.key});

  @override
  State<SeatItem_Nuris> createState() => _SeatItem_Nuris_state();
}

class _SeatItem_Nuris_state extends State<SeatItem_Nuris>{
  @override
  Widget build(BuildContext context) {
    return  Center(
        child: Text("Seat Page (placeholder)"),
      );
  }
}

Widget legendItem(String path, String label) {
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