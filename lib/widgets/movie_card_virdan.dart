import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../pages/detail_page_virdan.dart';

class MovieCardVirdan extends StatelessWidget {
  final QueryDocumentSnapshot movie;

  const MovieCardVirdan({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailPageVirdan(movie: movie),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Hero(
              tag: movie['poster_url'],
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  movie['poster_url'],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          ),

          const SizedBox(height: 6),
          // Judul Film
          Text(
            movie['title'],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          // Rating
          Text(
            "${movie['rating']} ⭐",
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),

          // Genre Film (Tambahan)
          Text(
            movie['genre'] ?? "Genre tidak diketahui",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.blueGrey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}