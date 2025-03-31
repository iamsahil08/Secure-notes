import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/auth_provider.dart';
import 'providers/note_provider.dart';
import 'app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main() async {
  // Ensure widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NoteProvider()),
      ],
      child: const NotesApp(),
    ),
  );
}
