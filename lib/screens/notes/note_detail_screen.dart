import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/note.dart';
import '../../providers/note_provider.dart';
import 'edit_note_screen.dart';

class NoteDetailScreen extends StatelessWidget {
  final Note note;
  
  const NoteDetailScreen({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditNoteScreen(note: note),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Provider.of<NoteProvider>(context, listen: false).deleteNote(note.id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last updated: ${note.updatedAt.day}/${note.updatedAt.month}/${note.updatedAt.year}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            const SizedBox(height: 16),
            Text(
              note.content,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}