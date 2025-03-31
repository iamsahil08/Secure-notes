import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/note.dart';
import '../../providers/auth_provider.dart';
import '../../providers/note_provider.dart';

class EditNoteScreen extends StatefulWidget {
  final Note? note;
  
  const EditNoteScreen({super.key, this.note});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    if (_formKey.currentState!.validate()) {
      final noteProvider = Provider.of<NoteProvider>(context, listen: false);
      
      if (widget.note == null) {
        // Create new note
        noteProvider.addNote(
          title: _titleController.text,
          content: _contentController.text,
          userId: Provider.of<AuthProvider>(context, listen: false).user!.id,
        );
      } else {
        // Update existing note
        noteProvider.updateNote(
          widget.note!.id,
          title: _titleController.text,
          content: _contentController.text,
        );
      }
      
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                  expands: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some content';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}