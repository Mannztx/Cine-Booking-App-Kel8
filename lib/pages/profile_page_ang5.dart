import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProfilePageAng5 extends StatelessWidget {
  const ProfilePageAng5({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .snapshots();

    final bookingStream = FirebaseFirestore.instance
        .collection("bookings")
        .where("user_id", isEqualTo: uid)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, "/login");
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: userDoc,
        builder: (context, userSnap) {
          if (!userSnap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData = userSnap.data!.data() as Map<String, dynamic>;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(userData["username"] ?? ""),
                subtitle: Text(userData["email"]),
                leading: const CircleAvatar(child: Icon(Icons.person)),
              ),
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "Riwayat Tiket:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: bookingStream,
                  builder: (context, snap) {
                    if (!snap.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final docs = snap.data!.docs;
                    if (docs.isEmpty) {
                      return const Center(child: Text("Belum ada booking"));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final data = docs[index].data() as Map<String, dynamic>;
                        final bookingId = data["booking_id"];

                        return Card(
                          child: ListTile(
                            title: Text(data["movie_title"]),
                            subtitle: Text("Kursi: ${data["seats"]}"),
                            trailing: QrImageView(
                              data: bookingId.toString(),
                              size: 65,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
