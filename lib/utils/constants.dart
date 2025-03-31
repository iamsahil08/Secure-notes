import 'package:flutter/material.dart';

class Constants {
  // App info
  static const String appName = 'Notes App';
  static const String appVersion = '1.0.0';
  
  // Routes
  static const String routeHome = '/home';
  static const String routeLogin = '/login';
  static const String routeRegister = '/register';
  static const String routeNoteDetail = '/note-detail';
  static const String routeEditNote = '/edit-note';
  
  // Firebase collections
  static const String collectionUsers = 'users';
  static const String collectionNotes = 'notes';
  
  // App colors
  static const Color primaryColor = Colors.blue;
  static const Color accentColor = Colors.blueAccent;
  static const Color backgroundColor = Colors.white;
  static const Color errorColor = Colors.red;
  
  // Note colors
  static final Map<String, Color> noteColors = {
    'blue': Colors.blue[50]!,
    'green': Colors.green[50]!,
    'yellow': Colors.yellow[50]!,
    'orange': Colors.orange[50]!,
    'red': Colors.red[50]!,
    'purple': Colors.purple[50]!,
  };
  
  // Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 150);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
}
