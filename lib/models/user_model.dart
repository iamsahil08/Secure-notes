import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;

  UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  // Create UserModel from Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      displayName: map['displayName'] as String?,
      photoUrl: map['photoUrl'] as String?,
    );
  }

  // Convert UserModel to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
    };
  }

  // Create from JSON string
  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  // Convert to JSON string
  String toJson() => json.encode(toMap());

  // Check if data exists
  bool get hasDisplayName => displayName != null && displayName!.isNotEmpty;
  bool get hasPhotoUrl => photoUrl != null && photoUrl!.isNotEmpty;
  
  // For profile display
  String get initials {
    if (hasDisplayName && displayName!.isNotEmpty) {
      final names = displayName!.split(' ');
      if (names.length > 1) {
        return '${names[0][0]}${names[1][0]}'.toUpperCase();
      }
      return displayName![0].toUpperCase();
    }
    return email[0].toUpperCase();
  }

  // Factory method to create a UserModel from a Firebase User
  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }
}
