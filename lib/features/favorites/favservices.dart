import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/notifcation audio state/model_song.dart';

class Favservices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Songg>> getLikedSongs(String userId) async {
    final likedSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('likedSongs')
        .get();

    if (likedSnapshot.docs.isEmpty) return [];

    final songIds = likedSnapshot.docs
        .map((doc) => doc['songId'] as String)
        .toList();

    final songsQuery = await _firestore
        .collection('songs')
        .where(FieldPath.documentId, whereIn: songIds)
        .get();

    return songsQuery.docs.map((doc) {
      final data = doc.data();
      return Songg(
        id: doc.id,
        title: data['title'] ?? '',
        audioUrl: data['audio_url'] ?? '',
        coverUrl: data['cover_url'] ?? '',
        artistId: data['artist_id'] ?? '',
      );
    }).toList();
  }
}
