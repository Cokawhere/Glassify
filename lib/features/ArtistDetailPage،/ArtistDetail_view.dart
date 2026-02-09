import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/styles/colors.dart';
import 'package:flutter_application_1/common/widgets/SongItem.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final userAsync = ref.watch(currentUser);
    final songsCount = artistSongs.maybeWhen(
      data: (songs) => songs.length,
      orElse: () => 0,
    );
    return Scaffold(
      body: Stack(
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
              child: Container(color: const Color.fromARGB(55, 62, 167, 139)),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0.r),

                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.subfont,
                    size: 30.r,
                  ),
                  onPressed: () {
                    context.pop();
                  },
                ),
              ),
            ),
          ),
          Positioned(
            top: 100.h,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  artist.name,
                  style: TextStyle(
                    fontSize: 40.sp,
                    color: AppColors.subfont,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${songsCount.toString()} Tracks',
                  style: TextStyle(
                    fontSize: 21.sp,
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
                padding: EdgeInsets.all(8.0.r),
                child: LiquidGlass(
                  glassContainsChild: false,
                  shape: LiquidRoundedRectangle(
                    borderRadius: Radius.circular(15.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.r),
                    child: SizedBox(
                      height: 600.h, // Using a fixed responsive height
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
                                      'userId': userAsync!.uid,
                                      'artistSongs': songsList,
                                    },
                                  );
                                },
                                child: Songitem(
                                  title: song.title,
                                  imageUrl: song.coverUrl,
                                  songId: song.id,
                                  artistId: artist.id,
                                  userId: userAsync!.uid ,
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
      ),
    );
  }
}
