import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/common/widgets/ArtistSection.dart';

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
}

