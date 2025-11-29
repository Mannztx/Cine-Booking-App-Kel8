import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailPageVirdan extends StatelessWidget {
  final QueryDocumentSnapshot movie;

  const DetailPageVirdan({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie['title'])),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/seat", arguments: movie);
        },
        child: const Icon(Icons.event_seat),
      ),
      body: ListView(
        children: [
          Hero(
            tag: movie['poster_url'],
            child: Image.network(movie['poster_url'], height: 300, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie['title'],
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                Text("Rating: ${movie['rating']} ⭐"),
                Text("Durasi: ${movie['duration']} menit"),
                Text("Harga Dasar: Rp ${movie['base_price']}"),

                const SizedBox(height: 20),
                const Text(
                  "Deskripsi film belum tersedia.",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
