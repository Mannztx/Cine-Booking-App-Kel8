import 'package:cloud_firestore/cloud_firestore.dart';
// digunakan untuk konversi tipe data waktu antara firestore dan dart

class UserModel_Firman {
  // Variabel state
  final String uid_Firman;
  final String email_Firman;
  final String username_Firman;
  final int balance_Firman;
  final DateTime createdAt_Firman;

  UserModel_Firman({
    required this.uid_Firman,
    required this.email_Firman,
    required this.username_Firman,
    required this.balance_Firman,
    required this.createdAt_Firman,
  });

  // Fungsi fromMap (Firebase Map -> Model)
  factory UserModel_Firman.fromMap_Firman(Map<String, dynamic> map) {
    return UserModel_Firman(
      uid_Firman: map['uid'] as String,
      email_Firman: map['email'] as String,
      username_Firman: map['username'] as String,
      balance_Firman: map['balance'] as int,
      // Timestamp dari firestore dikonversi menjadi datetime
      createdAt_Firman: (map['created_at'] as Timestamp).toDate(),
    );
  }

  // Fungsi toMap (Model -> Firebase Map)
  Map<String, dynamic> toMap_Firman() {
    return {
      'uid': uid_Firman,
      'email': email_Firman,
      'username': username_Firman,
      'balance': balance_Firman,
      // Mengkonversi datetime (dart) kembali ke timestamp (firestore)
      'created_at': Timestamp.fromDate(createdAt_Firman),
    };
  }
}