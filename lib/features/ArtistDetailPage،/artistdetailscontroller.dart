import 'package:flutter_application_1/features/ArtistDetailPage%D8%8C/artistdetails_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final artistServicesProvider = Provider<ArtistdetailsServices>(
  (ref) => ArtistdetailsServices(),
);

final artistSongsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((
  ref,
  artistId,
) {
  return ref.read(artistServicesProvider).getArtistSongs(artistId);
});

final likeSongProvider = Provider<LikeSongController>((ref) {
  return LikeSongController(ref.read(artistServicesProvider));
});

class LikeSongController {
  final ArtistdetailsServices _services;
  LikeSongController(this._services);

  Future<void> toggleLike({
    required bool isLiked,
    required String userId,
    required String artistId,
    required String songId,
  }) async {
    if (isLiked) {
      await _services.unlikeSong(userId: userId, songId: songId);
    } else {
      await _services.likeSong(
        userId: userId,
        songId: songId,
        artistId: artistId,
      );
    }
  }
}
