import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddSongPage extends StatefulWidget {
  const AddSongPage({super.key});

  @override
  State<AddSongPage> createState() => _AddSongPageState();
}

class _AddSongPageState extends State<AddSongPage> {
  final _titleController = TextEditingController();
  final _coverController = TextEditingController();
  final _audioController = TextEditingController();

  String? _selectedArtistId;

  void _saveSong(BuildContext context) async {
    final title = _titleController.text.trim();
    final coverUrl = _coverController.text.trim();
    final audioUrl = _audioController.text.trim();

    if (title.isEmpty || coverUrl.isEmpty || audioUrl.isEmpty || _selectedArtistId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('songs').add({
      'title': title,
      'cover_url': coverUrl,
      'audio_url': audioUrl,
      'artist_id': _selectedArtistId,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Song added successfully!')),
    );

    _titleController.clear();
    _coverController.clear();
    _audioController.clear();
    setState(() => _selectedArtistId = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Song")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('artists').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final artists = snapshot.data!.docs;
                return DropdownButton<String>(
                  value: _selectedArtistId,
                  hint: const Text("Select Artist"),
                  items: artists.map((doc) {
                    return DropdownMenuItem(
                      value: doc.id,
                      child: Text(doc['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedArtistId = value;
                    });
                  },
                );
              },
            ),
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: "Song Title")),
            TextField(controller: _coverController, decoration: const InputDecoration(labelText: "Cover URL")),
            TextField(controller: _audioController, decoration: const InputDecoration(labelText: "Audio URL")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _saveSong(context),
              child: const Text("Save Song"),
            )
          ],
        ),
      ),
    );
  }
}

