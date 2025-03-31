import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

class NoteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Collection reference
  CollectionReference get _notesCollection => _firestore.collection('notes');
  
  // Get notes for a specific user with real-time updates
  Stream<List<Note>> getNotes(String userId) {
    return _notesCollection
        .where('userId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Note.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }
  
  // Search notes by title or content
  Stream<List<Note>> searchNotes(String userId, String query) {
    // Convert to lowercase for case-insensitive search
    final String searchQuery = query.toLowerCase();
    
    return _notesCollection
        .where('userId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Note.fromMap(doc.data() as Map<String, dynamic>))
            .where((note) =>
                note.title.toLowerCase().contains(searchQuery) ||
                note.content.toLowerCase().contains(searchQuery))
            .toList());
  }
  
  // Get a single note by ID
  Future<Note?> getNoteById(String noteId) async {
    final docSnapshot = await _notesCollection.doc(noteId).get();
    
    if (docSnapshot.exists) {
      return Note.fromMap(
        docSnapshot.data() as Map<String, dynamic>,
      );
    }
    
    return null;
  }
  
  // Add a new note
  Future<Note> addNote(String userId, String title, String content, String? color) async {
    final timestamp = DateTime.now();
    
    final data = {
      'userId': userId,
      'title': title,
      'content': content,
      'createdAt': Timestamp.fromDate(timestamp),
      'updatedAt': Timestamp.fromDate(timestamp),
      'color': color,
    };
    
    final docRef = await _notesCollection.add(data);
    
    return Note(
      id: docRef.id,
      userId: userId,
      title: title,
      content: content,
      createdAt: timestamp,
      updatedAt: timestamp,
      color: color,
    );
  }
  
  // Update an existing note
  Future<void> updateNote(Note note) async {
    await _notesCollection.doc(note.id).update(note.toMap());
  }
  
  // Delete a note
  Future<void> deleteNote(String noteId) async {
    await _notesCollection.doc(noteId).delete();
  }
}
