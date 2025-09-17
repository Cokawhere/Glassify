import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/features/ArtistDetailPage،/artistdetailscontroller.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import '../../main.dart';
import '../../features/notifcation audio state/controller.dart';
import '../../features/notifcation audio state/model_song.dart';
import '../../features/home/home_services.dart';
import '../styles/colors.dart';

class CurrentSongWidget extends ConsumerWidget {
  final String currentUserId;
  const CurrentSongWidget({super.key, required this.currentUserId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongProvider);
    final audioController = ref.read(audioControlerProvider);
    final playbackState = ref.watch(playBackStateProvider);

    if (currentSong == null) return const SizedBox.shrink();

    final isPlaying =
        playbackState.value?.playing == true &&
        (playbackState.value?.processingState !=
            AudioProcessingState.completed);

    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(16),
      color: AppColors.pink.withOpacity(0.9),
      child: InkWell(
        onTap: () async {
          final mediaItems = audioHandler.queue.value;
          final queue = mediaItems.map((item) {
            final fallbackDur = item.extras?['duration'] != null
                ? Duration(milliseconds: item.extras!['duration'] as int)
                : null;
            return Songg(
              id: item.id,
              title: item.title,
              artistId: item.album ?? '',
              coverUrl: item.artUri.toString(),
              audioUrl: item.extras?['url'] as String? ?? '',
              duration: fallbackDur,
            );
          }).toList();
          final artist = await getArtistFromSongId(currentSong.id);
          context.push(
            '/songdetails',
            extra: {
              'song': currentSong,
              'artist': artist,
              'userId': currentUserId,
              'artistSongs': queue.isNotEmpty ? queue : [currentSong],
            },
          );
        },
        child: LiquidGlass(
          glassContainsChild: false,
          shape: LiquidRoundedRectangle(borderRadius: Radius.circular(16)),
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    currentSong.coverUrl,
                    width: 55,
                    height: 55,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      size: 55,
                      color: Colors.white70,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentSong.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      ref
                          .watch(artistDetailsProvider(currentSong.artistId))
                          .when(
                            data: (artist) => Text(
                              artist.name,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            loading: () => const SizedBox.shrink(),
                            error: (e, st) => const Text(
                              'Unknown Artist',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 13,
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    if (isPlaying) {
                      audioController.pauseSong();
                    } else {
                      audioController.resumeSong();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
