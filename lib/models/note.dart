import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String userId;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? color;

  Note({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.color,
  });

  // Create a Note from a Map 
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as String,
      userId: map['userId'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      color: map['color'] as String?,
    );
  }

  // Convert Note to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'color': color,
    };
  }

  // Create from JSON string
  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));

  // Convert to JSON string
  String toJson() => json.encode(toMap());

  // Create a copy of Note with updated fields
  Note copyWith({
    String? title,
    String? content,
    String? color,
    DateTime? updatedAt
  }) {
    return Note(
      id: id,
      userId: userId,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      color: color ?? this.color,
    );
  }

  // Create Note from Firestore document
  factory Note.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Note(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      color: data['color'] as String?,
    );
  }

  // Convert Note to Map for Firestore
  Map<String, dynamic> toFirestoreMap() {
    return {
      'userId': userId,
      'title': title,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'color': color,
    };
  }

  // Create a copy of Note with some fields updated
  Note copyWithFirestore({
    String? title,
    String? content,
    DateTime? updatedAt,
    String? color,
  }) {
    return Note(
      id: id,
      userId: userId,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      color: color ?? this.color,
    );
  }
}
