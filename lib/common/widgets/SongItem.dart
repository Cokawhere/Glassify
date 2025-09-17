import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/styles/colors.dart';
import 'package:flutter_application_1/features/ArtistDetailPage%D8%8C/artistdetailscontroller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/favorites/favcontroller.dart';
import '../../features/notifcation audio state/model_song.dart';

class Songitem extends ConsumerStatefulWidget {
  final String title;
  final String imageUrl;
  final String songId;
  final String artistId;
  final String audioUrl;
  final String userId;

  const Songitem({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.songId,
    required this.artistId,
    required this.audioUrl,
    required this.userId,
  });

  @override
  ConsumerState<Songitem> createState() => _SongitemState();
}

class _SongitemState extends ConsumerState<Songitem> {
  @override
  Widget build(BuildContext context) {
    final likeSongController = ref.watch(likeSongProvider);
    if (widget.userId.isEmpty || widget.songId.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 3, vertical: 6),
        child: Row(
          children: [Text('Invalid data', style: TextStyle(color: Colors.red))],
        ),
      );
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3, vertical: 6),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.imageUrl),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),

          SizedBox(width: 4),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(6.0),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ref
                      .watch(artistDetailsProvider(widget.artistId))
                      .when(
                        data: (artist) => Text(
                          artist.name,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                        loading: () => const SizedBox(
                          height: 10,
                          width: 40,
                          child: LinearProgressIndicator(
                            backgroundColor: AppColors.subfont,
                          ),
                        ),
                        error: (e, st) => const Text(
                          'N/A',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                ],
              ),
            ),
          ),
          StreamBuilder<bool>(
            stream: ref
                .read(artistServicesProvider)
                .isSongLiked(widget.userId, widget.songId),
            builder: (context, snapshots) {
              final isLiked = snapshots.data ?? false;
              return IconButton(
                onPressed: () async {
                  if (isLiked) {
                    ref
                        .read(likedSongsProvider.notifier)
                        .removeSongLocally(widget.songId);
                  } else {
                    final newSong = Songg(
                      id: widget.songId,
                      title: widget.title,
                      artistId: widget.artistId,
                      coverUrl: widget.imageUrl,
                      audioUrl: widget.audioUrl,
                    );
                    ref
                        .read(likedSongsProvider.notifier)
                        .addSongLocally(newSong);
                  }
                  await likeSongController.toggleLike(
                    isLiked: isLiked,
                    userId: widget.userId,
                    artistId: widget.artistId,
                    songId: widget.songId,
                  );
                },
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: AppColors.subfont,
                  size: 30,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
