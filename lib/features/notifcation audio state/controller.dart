import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import '../../main.dart';
import 'audio_handler.dart';
import 'model_song.dart';

class CurrentSongNotifier extends StateNotifier<Songg?> {
  StreamSubscription<Songg?>? _sub;

  CurrentSongNotifier() : super(null) {
    _sub = Rx.combineLatest2<MediaItem?, Duration?, Songg?>(
      audioHandler.mediaItem,
      (audioHandler as MyAudioHandler).player.durationStream,
      (item, dur) {
        if (item == null) return null;
        final fallbackDur = item.extras?['duration'] != null
            ? Duration(milliseconds: item.extras!['duration'] as int)
            : Duration.zero;
        return Songg(
          id: item.id,
          title: item.title,
          artistId: item.artist ?? '', // Read from the correct 'artist' field
          coverUrl: item.artUri.toString(),
          audioUrl: item.extras?['url'] as String? ?? '',
          duration: dur ?? fallbackDur,
        );
      },
    ).listen((song) => state = song);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

final currentSongProvider = StateNotifierProvider<CurrentSongNotifier, Songg?>((
  ref,
) {
  return CurrentSongNotifier();
});

final playBackStateProvider = StreamProvider<PlaybackState>(
  (ref) => audioHandler.playbackState,
);

class AudioController {
  final Ref ref;
  AudioController(this.ref);

  bool _isQueueSame(List<MediaItem> currentQueue, List<Songg> newSongQueue) {
    if (currentQueue.length != newSongQueue.length) return false;
    for (var i = 0; i < currentQueue.length; i++) {
      if (currentQueue[i].id != newSongQueue[i].id) return false;
    }
    return true;
  }

  Future<void> prepareSong(Songg song, List<Songg> queue) async {
    final currentMediaItems = audioHandler.queue.value;

    if (!_isQueueSame(currentMediaItems, queue)) {
      final mediaItems = queue
          .map(
            (s) => MediaItem(
              id: s.id,
              title: s.title,
              artist:
                  s.artistName ??
                  s.artistId, // Use artistName if available, fallback to ID
              artUri: Uri.parse(s.coverUrl),
              extras: {
                'url': s.audioUrl,
                'duration': s.duration?.inMilliseconds,
              },
            ),
          )
          .toList();
      await audioHandler.updateQueue(mediaItems);
    }
    final index = queue.indexWhere((s) => s.id == song.id);
    if (index != -1) {
      if (audioHandler.mediaItem.value?.id != song.id) {
        await audioHandler.skipToQueueItem(index);
      }
    }
  }

  Future<void> playSong(Songg song, List<Songg> queue) async {
    final current = ref.read(currentSongProvider);
    if (current?.id != song.id) {
      await prepareSong(song, queue);
    }
    resumeSong();
  }

  void pauseSong() => audioHandler.pause();
  void resumeSong() => audioHandler.play();
  void stopSong() => audioHandler.stop();
}

final audioControlerProvider = Provider((ref) => AudioController(ref));
