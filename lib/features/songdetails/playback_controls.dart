import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:rxdart/rxdart.dart';
import '../../common/styles/colors.dart';
import '../../main.dart';
import '../notifcation audio state/audio_handler.dart';
import '../notifcation audio state/controller.dart';
import '../notifcation audio state/model_song.dart';

final localPositionProvider = StateProvider<Duration>((ref) => Duration.zero);
final localDurationProvider = StateProvider<Duration>((ref) => Duration.zero);
final localIsPlayingProvider = StateProvider<bool>((ref) => false);

class PlaybackControls extends ConsumerWidget {
  final Songg displayedSong;
  final List<Songg> queue;
  final void Function(Songg) onSongChanged;

  const PlaybackControls({
    super.key,
    required this.displayedSong,
    required this.queue,
    required this.onSongChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioController = ref.read(audioControlerProvider);
    final playbackState = ref.watch(playBackStateProvider);
    final currentSong = ref.watch(currentSongProvider);
    final player = (audioHandler as MyAudioHandler).player;

    final isCurrentSong = currentSong?.id == displayedSong.id;

    final playback = playbackState.value;
    final isPlaying = isCurrentSong && playback?.playing == true;

    final posStream =
        Rx.combineLatest2<Duration, Duration?, Map<String, Duration>>(
          player.positionStream,
          player.durationStream,
          (pos, dur) => {
            'pos': pos,
            'dur': dur ?? displayedSong.duration ?? Duration.zero,
          },
        );

    return Column(
      children: [
        StreamBuilder<Map<String, Duration>>(
          stream: posStream,
          builder: (context, snapshot) {
            final isCurrent = currentSong?.id == displayedSong.id;
            final pos = isCurrent
                ? (snapshot.data?['pos'] ?? Duration.zero)
                : Duration.zero;
            final total = isCurrent
                ? (snapshot.data?['dur'] ?? Duration.zero)
                : displayedSong.duration ?? Duration.zero;

            final maxMs = total.inMilliseconds > 0
                ? total.inMilliseconds.toDouble()
                : 1.0;
            final sliderValue = isCurrent && total.inMilliseconds > 0
                ? pos.inMilliseconds.clamp(0, total.inMilliseconds).toDouble()
                : 0.0;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Glassify(
                    child: SliderTheme(
                      data: SliderThemeData(trackHeight: 10),
                      child: Slider(
                        min: 0,
                        max: maxMs,
                        value: sliderValue,
                        onChanged: (isCurrent && total.inMilliseconds > 0)
                            ? (value) {
                                audioHandler.seek(
                                  Duration(milliseconds: value.toInt()),
                                );
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${pos.inMinutes}:${pos.inSeconds.remainder(60).toString().padLeft(2, '0')}",
                        style: const TextStyle(
                          color: AppColors.subfont,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${total.inMinutes}:${total.inSeconds.remainder(60).toString().padLeft(2, '0')}",
                        style: const TextStyle(
                          color: AppColors.subfont,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () async {
                final currentIndex = queue.indexWhere(
                  (s) => s.id == currentSong?.id,
                );
                if (currentIndex > 0) {
                  final prevSong = queue[currentIndex - 1];
                  await audioController.playSong(prevSong, queue);
                  ref.read(currentSongProvider.notifier).state = prevSong;
                  onSongChanged(prevSong);
                }
              },
              icon: const Icon(
                Icons.skip_previous,
                color: Colors.white,
                size: 55,
              ),
            ),
            IconButton(
              onPressed: () async {
                if (isPlaying) {
                  audioController.pauseSong();
                } else {
                  await audioController.playSong(displayedSong, queue);
                }
              },
              icon: Icon(
                isPlaying ? Icons.pause_circle : Icons.play_circle,
                color: Colors.white,
                size: 75,
              ),
            ),
            IconButton(
              onPressed: () async {
                final currentIndex = queue.indexWhere(
                  (s) => s.id == currentSong?.id,
                );
                if (currentIndex < queue.length - 1) {
                  final nextSong = queue[currentIndex + 1];
                  await audioController.playSong(nextSong, queue);
                  ref.read(currentSongProvider.notifier).state = nextSong;
                  onSongChanged(nextSong);
                }
              },
              icon: const Icon(Icons.skip_next, color: Colors.white, size: 55),
            ),
          ],
        ),
      ],
    );
  }
}
