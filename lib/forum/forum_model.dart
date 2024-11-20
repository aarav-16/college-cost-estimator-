import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ForumModel {
  final String? forumId;
  final String title;
  final String description;
  final String userId;
  final Timestamp addedDate;
  ForumModel({
    this.forumId,
    required this.title,
    required this.description,
    required this.userId,
    required this.addedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'userId': userId,
      'addedDate': addedDate,
    };
  }

  factory ForumModel.fromMap(QueryDocumentSnapshot<Map<String, dynamic>> map) {
    return ForumModel(
      forumId: map.id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      userId: map['userId'] ?? '',
      addedDate: map['addedDate'],
    );
  }
}

class ReplyModel {
  final String? replyId;
  final String replyText;
  final String forumId;
  final String userId;
  final Timestamp addedDate;
  ReplyModel({
    this.replyId,
    required this.replyText,
    required this.forumId,
    required this.userId,
    required this.addedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'replyText': replyText,
      'forumId': forumId,
      'userId': userId,
      'addedDate': addedDate,
    };
  }

  factory ReplyModel.fromMap(QueryDocumentSnapshot<Map<String, dynamic>> map) {
    return ReplyModel(
      replyId: map.id,
      replyText: map['replyText'] ?? '',
      forumId: map['forumId'] ?? '',
      userId: map['userId'] ?? '',
      addedDate: map['addedDate'],
    );
  }
}
