import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/common/widgets/ArtistSection.dart';
import 'package:flutter_application_1/common/widgets/Songsection.dart';

class HomeServices {
  Future<List<Artist>> getArtists() async {
    try {
      final snapshots = await FirebaseFirestore.instance
          .collection("artists")
          .get();
      return snapshots.docs.map((doc) {
        final data = doc.data();
        return Artist(imageUrl: data['image_url'], name: data['name']);
      }).toList();
    } catch (e) {
      print('faild to fetch artist list :$e');
      return [];
    }
  }

  Future<List<Song>> getSongs() async {
    try {
      final songsQuery = await FirebaseFirestore.instance
          .collection("songs")
          .get();
      final artisQuery = await FirebaseFirestore.instance
          .collection("artists")
          .get();
      final artisMap = {
        for (var doc in artisQuery.docs) doc.id: doc.data()['name'] ?? '',
      };
      return songsQuery.docs.map((doc) {
        final song = doc.data();
        final artistName = artisMap[song['artist_id']] ?? "UnKnowen";
        return Song(
          imageUrl: song['cover_url'],
          songName: song['title'],
          artistName: artistName,
        );
      }).toList();
    } catch (e) {
      print('e');
      return [];
    }
  }
}
