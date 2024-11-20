import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Usermodel {
  final String? userId;
  final String username;
  final String? profileImg;
  final String email;
  final Timestamp addedDate;
  Usermodel({
    this.userId,
    required this.username,
    this.profileImg,
    required this.email,
    required this.addedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'profileImg': profileImg,
      'email': email,
      'addedDate': addedDate,
    };
  }

  factory Usermodel.fromMap(DocumentSnapshot<Map<String, dynamic>> map) {
    return Usermodel(
      userId: map.id,
      username: map['username'],
      profileImg: map['profileImg'],
      email: map['email'] ?? '',
      addedDate: map['addedDate'],
    );
  }
}
