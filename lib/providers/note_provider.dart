import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/note.dart';

class NoteProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Note> _notes = [];
  String? _error;
  bool _isLoading = false;
  String? _searchQuery;
  
  // Getters
  List<Note> get notes => _searchQuery != null && _searchQuery!.isNotEmpty
      ? _filterNotes(_searchQuery!)
      : _notes;
  String? get error => _error;
  bool get isLoading => _isLoading;
  
  // Load notes for specific user
  Future<void> loadUserNotes(String userId) async {
    try {
      _setLoading(true);
      _clearError();
      
      final snapshot = await _firestore
          .collection('notes')
          .where('userId', isEqualTo: userId)
          .orderBy('updatedAt', descending: true)
          .get();
      
      _notes = snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList();
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load notes: $e');
      _setLoading(false);
    }
  }
  
  // Add a new note
  Future<Note?> addNote({
    required String title,
    required String content,
    required String userId,
  }) async {
    try {
      _setLoading(true);
      _clearError();
      
      final now = DateTime.now();
      final noteData = {
        'userId': userId,
        'title': title,
        'content': content,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      };
      
      // Add to Firestore and get the auto-generated ID
      final docRef = await _firestore.collection('notes').add(noteData);
      
      // Create note object with the Firestore-generated ID
      final note = Note(
        id: docRef.id,
        userId: userId,
        title: title,
        content: content,
        createdAt: now,
        updatedAt: now,
      );
      
      // Add to local list
      _notes.insert(0, note);
      
      _setLoading(false);
      notifyListeners();
      return note;
    } catch (e) {
      _setError('Failed to add note: $e');
      _setLoading(false);
      return null;
    }
  }
  
  // Update existing note
  Future<bool> updateNote(
    String id, {
    required String title,
    required String content,
  }) async {
    try {
      _setLoading(true);
      _clearError();
      
      final now = DateTime.now();
      final updates = {
        'title': title,
        'content': content,
        'updatedAt': now.toIso8601String(),
      };
      
      // Update in Firestore
      await _firestore.collection('notes').doc(id).update(updates);
      
      // Update local list
      final index = _notes.indexWhere((note) => note.id == id);
      if (index != -1) {
        _notes[index] = _notes[index].copyWith(
          title: title,
          content: content,
          updatedAt: now,
        );
        _notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      }
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to update note: $e');
      _setLoading(false);
      return false;
    }
  }
  
  // Delete note
  Future<bool> deleteNote(String id) async {
    try {
      _setLoading(true);
      _clearError();
      
      // Delete from Firestore
      await _firestore.collection('notes').doc(id).delete();
      
      // Remove from local list
      _notes.removeWhere((note) => note.id == id);
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to delete note: $e');
      _setLoading(false);
      return false;
    }
  }

  // Helper methods
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  
  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }
  
  void _clearError() {
    _error = null;
  }
  
  List<Note> _filterNotes(String query) {
    final lowerQuery = query.toLowerCase();
    return _notes.where((note) {
      return note.title.toLowerCase().contains(lowerQuery) ||
          note.content.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
