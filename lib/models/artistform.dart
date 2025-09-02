import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddArtistPage extends StatelessWidget {
  final _nameController = TextEditingController();
  final _imageController = TextEditingController();

  AddArtistPage({super.key});

  void _saveArtist(BuildContext context) async {
    final name = _nameController.text.trim();
    final imageUrl = _imageController.text.trim();

    if (name.isEmpty || imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('artists').add({
      'name': name,
      'image_url': imageUrl,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Artist added successfully!')),
    );
    _nameController.clear();
    _imageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Artist")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Artist Name")),
            TextField(controller: _imageController, decoration: const InputDecoration(labelText: "Artist Image URL")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _saveArtist(context),
              child: const Text("Save Artist"),
            )
          ],
        ),
      ),
    );
  }
}
