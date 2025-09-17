import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Auth/controller.dart';
import '../notifcation audio state/model_song.dart';
import 'favservices.dart';

final likedSongsProvider = StateNotifierProvider<LikedSongsNotifier, AsyncValue<List<Songg>>>( (ref) => LikedSongsNotifier(ref), );

class LikedSongsNotifier extends StateNotifier<AsyncValue<List<Songg>>> {
  final Ref ref;
  final _service = Favservices();

  LikedSongsNotifier(this.ref) : super(const AsyncLoading()) {
    fetch();
  }

  Future<void> fetch() async {
    try {
      final currentUser = await ref.watch(userStreamProvider.future);
      if (currentUser == null) {
        state = const AsyncData([]);
        return;
      }
      final songs = await _service.getLikedSongs(currentUser.uid);
      state = AsyncData(songs);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  void removeSongLocally(String songId) {
    final currentList = List<Songg>.from(state.value ?? []);
    currentList.removeWhere((s) => s.id == songId);
    state = AsyncData(currentList);
  }

  void addSongLocally(Songg song) {
    final currentList = List<Songg>.from(state.value ?? []);
    if (!currentList.any((s) => s.id == song.id)) {
      currentList.add(song);
      state = AsyncData(currentList);
    }
  }
}
