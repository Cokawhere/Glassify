import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/styles/colors.dart';
import 'package:flutter_application_1/common/widgets/SongItem.dart';
import 'package:flutter_application_1/features/ArtistDetailPage%D8%8C/artistdetailscontroller.dart';
import 'package:flutter_application_1/models/artist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import '../../common/widgets/app_loader.dart';

import '../Auth/controller.dart';
import '../notifcation audio state/model_song.dart';

class ArtistdetailView extends ConsumerWidget {
  final Artist artist;

  const ArtistdetailView({super.key, required this.artist});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artistSongs = ref.watch(artistSongsProvider(artist.id));
    final userAsync = ref.watch(userStreamProvider);
    return Scaffold(
      body: userAsync.when(
        data: (user) {
          final currentUserId = user?.uid ?? '';
          final songsCount = artistSongs.maybeWhen(
            data: (songs) => songs.length,
            orElse: () => 0,
          );
          return Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  artist.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const AppLoader();
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.error, color: Colors.red),
                    );
                  },
                ),
              ),

              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(
                    color: const Color.fromARGB(55, 62, 167, 139),
                  ),
                ),
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),

                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.subfont,
                        size: 30,
                      ),
                      onPressed: () {
                        context.pop();
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 100,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      artist.name,
                      style: TextStyle(
                        fontSize: 40,
                        color: AppColors.subfont,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${songsCount.toString()} Tracks',
                      style: TextStyle(
                        fontSize: 21,
                        color: AppColors.font,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),

              SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LiquidGlass(
                      glassContainsChild: false,
                      shape: LiquidRoundedRectangle(
                        borderRadius: Radius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * .7,
                          child: artistSongs.when(
                            data: (songsData) {
                              final songsList = songsData
                                  .map((s) => Songg.formMap(s, s['id'] ?? ''))
                                  .toList();
                              return ListView.builder(
                                itemCount: songsList.length,
                                itemBuilder: (context, index) {
                                  final song = songsList[index];
                                  return InkWell(
                                    onTap: () async {
                                     
                                      context.push(
                                        '/songdetails',
                                        extra: {
                                          'song': song,
                                          'artist': artist,
                                          'userId': currentUserId,
                                          'artistSongs': songsList,
                                        },
                                      );
                                    },
                                    child: Songitem(
                                      title: song.title,
                                      imageUrl: song.coverUrl,
                                      songId: song.id,
                                      artistId: artist.id,
                                      userId: currentUserId ?? '',
                                      audioUrl: song.audioUrl,
                                    ),
                                  );
                                },
                              );
                            },
                            error: (error, stackTrace) {
                              return Center(child: Text('Error: $error'));
                            },
                            loading: () => const AppLoader(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const AppLoader(),
        error: (error, stackTrace) => Center(
          child: Text('Error: $error', style: TextStyle(color: Colors.red)),
        ),
      ),
    );
  }
}
