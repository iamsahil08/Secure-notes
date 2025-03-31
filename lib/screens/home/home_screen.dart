import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/note.dart';
import '../../providers/auth_provider.dart';
import '../../providers/note_provider.dart';
import '../notes/edit_note_screen.dart';
import '../notes/note_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load notes when screen initializes
    final userId = Provider.of<AuthProvider>(context, listen: false).user!.id;
    Provider.of<NoteProvider>(context, listen: false).loadUserNotes(userId);
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).signOut();
            },
          ),
        ],
      ),
      body: noteProvider.notes.isEmpty
          ? Center(child: Text('No notes yet. Add your first note! \n ${Provider.of<AuthProvider>(context, listen: false).user?.email}'))
          : ListView.builder(
              itemCount: noteProvider.notes.length,
              itemBuilder: (context, index) {
                final note = noteProvider.notes[index];
                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(
                    note.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    '${note.updatedAt.day}/${note.updatedAt.month}/${note.updatedAt.year}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteDetailScreen(note: note),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EditNoteScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}