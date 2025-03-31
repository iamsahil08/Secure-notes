import 'package:flutter/material.dart';
import '../models/note.dart';
import '../utils/constants.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  
  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      color: _getNoteColor(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Note title
              Text(
                note.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              
              // Note preview
              Text(
                note.content,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              
              // Last updated date
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 14,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(note.updatedAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Color _getNoteColor() {
    if (note.color == null) {
      return Colors.white;
    }
    
    return Constants.noteColors[note.color] ?? Colors.white;
  }
  
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
