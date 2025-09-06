import 'package:audio_service/audio_service.dart';
import 'package:flutter_application_1/features/notifcation%20audio%20state/model_song.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'audio_handler.dart';

final currentSongProvider = StateProvider<Song?>((ref) => null);

final audioControlerProvider = Provider((ref) {
  return AudioController(ref);
});

final playBackStateProvider = StreamProvider<PlaybackState>(
  (ref) => audioHandler.playbackState,
);

class AudioController {
  final Ref ref;
  AudioController(this.ref);

  void playSong(Song song) async {
    ref.read(currentSongProvider.notifier).state = song;

    await (audioHandler as MyAudioHandler).playSong(
      song.title,
      song.artistId,
      song.audioUrl,
      song.coverUrl,
    );
  }

  void pauseSong() => audioHandler.pause();
  void resumeSong() => audioHandler.play();
  void stopSong() => audioHandler.stop();
}
