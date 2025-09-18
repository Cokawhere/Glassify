import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import '../../models/artist.dart';
import '../ArtistDetailPage،/artistdetailscontroller.dart';
import '../favorites/favcontroller.dart';
import '../notifcation audio state/model_song.dart';

class LikeButtonRow extends ConsumerWidget {
  final Songg song;
  final Artist artist;
  final String userId;

  const LikeButtonRow({
    super.key,
    required this.song,
    required this.artist,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likeSongController = ref.watch(likeSongProvider);
    return LiquidGlass(
      shape: LiquidRoundedRectangle(borderRadius: Radius.circular(40)),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white,
              size: 50,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const Spacer(),
          StreamBuilder<bool>(
            stream: ref
                .read(artistServicesProvider)
                .isSongLiked(userId, song.id),
            builder: (context, snapshot) {
              final isLiked = snapshot.data ?? false;
              return IconButton(
                onPressed: () async {
                  if (isLiked) {
                    ref
                        .read(likedSongsProvider.notifier)
                        .removeSongLocally(song.id);
                  } else {
                    ref.read(likedSongsProvider.notifier).addSongLocally(song);
                  }
                  await likeSongController.toggleLike(
                    isLiked: isLiked,
                    userId: userId,
                    artistId: song.artistId,
                    songId: song.id,
                  );
                },
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                  size: 34,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
