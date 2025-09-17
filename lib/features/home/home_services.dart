import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/features/notifcation%20audio%20state/model_song.dart';

import '../../models/artist.dart';

class HomeServices {
  Future<List<Artist>> getArtists() async {
    try {
      final snapshots = await FirebaseFirestore.instance
          .collection("artists")
          .get();
      return snapshots.docs.map((doc) {
        final data = doc.data();
        return Artist.fromJson(doc.id, data);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Songg>> getSongs() async {
    try {
      final songsQuery = await FirebaseFirestore.instance
          .collection("songs")
          .get();
      return songsQuery.docs.map((doc) {
        final song = doc.data();
        return Songg(
          coverUrl: song['cover_url'],
          title: song['title'],
          artistId: song['artist_id'] ?? '',
          audioUrl: song['audio_url'] ?? '',
          id: doc.id,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }
}

Future<Artist> getArtistFromSongId(String songId) async {
  final songDoc = await FirebaseFirestore.instance
      .collection('songs')
      .doc(songId)
      .get();

  if (!songDoc.exists) throw Exception('Song not found');

  final artistId = songDoc.data()?['artist_id'];
  if (artistId == null) throw Exception('Artist ID not found in song');

  final artistDoc = await FirebaseFirestore.instance
      .collection('artists')
      .doc(artistId)
      .get();

  if (!artistDoc.exists) throw Exception('Artist not found');

  return Artist.fromJson(artistDoc.id, artistDoc.data()!);
}
