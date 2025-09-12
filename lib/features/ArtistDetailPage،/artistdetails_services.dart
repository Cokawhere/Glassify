import 'package:cloud_firestore/cloud_firestore.dart';

class ArtistdetailsServices {
  Future<List<Map<String, dynamic>>> getArtistSongs(String artistId) async {
    try {
      final snapshots = await FirebaseFirestore.instance
          .collection("songs")
          .where("artist_id", isEqualTo: artistId)
          .get();
      return snapshots.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    } catch (e) {
      print("fialed to fetch artist's songs :$e");
      return [];
    }
  }

  Future<void> likeSong({
    required String userId,
    required String songId,
    required String artistId,
  }) async {
    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("likedSongs")
        .doc(songId);
    await ref.set({
      'artistId': artistId,
      'songId': songId,
      'likedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> unlikeSong({
    required String userId,
    required String songId,
  }) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('likedSongs')
        .doc(songId)
        .delete();
  }

  Stream<bool> isSongLiked(String userId, String songId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("likedSongs")
        .doc(songId)
        .snapshots()
        .map((doc) => doc.exists);
  }
}
