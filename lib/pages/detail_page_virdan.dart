import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailPageVirdan extends StatelessWidget {
  final QueryDocumentSnapshot movie;

  const DetailPageVirdan({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie['title'])),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, "/seat", arguments: movie);
        },
        label: const Text("Book Ticket"),
        icon: const Icon(Icons.event_seat),
      ),

      body: ListView(
        children: [
          // Poster
          Hero(
            tag: movie['poster_url'],
            child: Image.network(
              movie['poster_url'],
              height: 320,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie['title'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text("Rating: ${movie['rating']} ⭐"),
                Text("Durasi: ${movie['duration']} menit"),
                Text("Harga Dasar: Rp ${movie['base_price']}"),

                const SizedBox(height: 20),

                const Text(
                  "Deskripsi belum tersedia. Tambahkan dari Firebase Console jika ingin.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
