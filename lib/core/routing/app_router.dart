import 'package:flutter_application_1/features/favorites/favorites_view.dart';
import 'package:flutter_application_1/features/home/Mainscreen/mainscreen_view.dart';
import 'package:flutter_application_1/features/notifcation%20audio%20state/model_song.dart';
import 'package:flutter_application_1/features/settings/settings_view.dart';
import 'package:flutter_application_1/features/songdetails/Songdetailsview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/ArtistDetailPage،/ArtistDetail_view.dart';
import '../../features/Auth/controller.dart';
import '../../features/auth/view/login_view.dart';
import '../../features/auth/view/signup_view.dart';
import '../../features/home/home_view.dart';
import '../../models/artist.dart';





GoRouter createRouter(WidgetRef ref) {
  final userStream = ref.watch(userStreamProvider);

  return GoRouter(
    initialLocation: '/main',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/main', builder: (context, state) => const MainScreen()),
      GoRoute(
        path: '/fav',
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: '/set',
        builder: (context, state) => const SettingsScreen(),
      ),

      GoRoute(
        path: '/artistdetails',
        builder: (context, state) {
          final artist = state.extra as Artist;
          return ArtistdetailView(artist: artist);
        },
      ),
      GoRoute(
        path: '/songdetails',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          final song = data['song'] as Songg;
          final artist = data['artist'] as Artist;
          final userId = data['userId'] as String;
          final artistSongs = data['artistSongs'] as List<Songg>;

          return SongDetailsView(
            userId: userId,
            artistSongs: artistSongs,
            song: song,
            artist: artist,
          );
        },
      ),
    ],
    redirect: (context, state) {
      final currentPath = state.uri.toString();

      if (userStream.isLoading) return null;

      if (userStream.hasError) return '/login';

      final user = userStream.value;

      if (user == null && currentPath != '/login' && currentPath != '/signup') {
        return '/login';
      }

      if (user != null &&
          (currentPath == '/login' || currentPath == '/signup')) {
        return '/main';
      }

      // if (user != null &&
      //     (currentPath == '/login' || currentPath == '/signup')) {
      //   final last = ref.read(lastPathProvider);
      //   return last == '/login' || last == '/signup' ? '/main' : last;
      // }

      return null;
    },
  );
}
