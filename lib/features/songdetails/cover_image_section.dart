import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/artist.dart';
import '../notifcation audio state/model_song.dart';

class CoverImageSection extends ConsumerWidget {
  final Songg song;
  final Artist artist;

  const CoverImageSection({
    super.key,
    required this.song,
    required this.artist,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            song.coverUrl,
            fit: BoxFit.cover,
            width: 250,
            height: 250,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.broken_image,
              size: 250,
              color: Colors.white70,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          song.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          artist.name,
          style: const TextStyle(color: Colors.white70, fontSize: 20),
        ),
      ],
    );
  }
}
