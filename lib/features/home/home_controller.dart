import 'package:flutter_application_1/features/home/home_services.dart';
import 'package:flutter_application_1/features/notifcation%20audio%20state/model_song.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/artist.dart';

final homeServicesProvider = Provider((ref) => HomeServices());

final artistProvider = FutureProvider<List<Artist>>((ref) async {
  final homeServices = ref.watch(homeServicesProvider);
  return await homeServices.getArtists();
});

final newReleasesFutureProvider = FutureProvider<List<Songg>>((ref) async {
  final homeService = ref.watch(homeServicesProvider);
  return homeService.getSongs();
});

final alphabeticalSongsProvider = FutureProvider<List<Songg>>((ref) async {
  final homeServices = ref.read(homeServicesProvider);
  List<Songg> songs = await homeServices.getSongs();
  songs.sort((a, b) => a.title.compareTo(b.title));
  return songs;
});
