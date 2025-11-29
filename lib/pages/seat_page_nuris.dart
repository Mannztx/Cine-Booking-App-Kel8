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
          // legend bar
          
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
