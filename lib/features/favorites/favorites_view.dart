import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/styles/colors.dart';
import 'package:flutter_application_1/common/widgets/SongItem.dart';
import 'package:flutter_application_1/features/Auth/controller.dart';
import 'package:flutter_application_1/features/favorites/favcontroller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_glass_renderer/experimental.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import '../../common/widgets/app_loader.dart';

import '../home/home_services.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likedSongsAsync = ref.watch(likedSongsProvider);
    final userAsync = ref.watch(currentUser);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.pink,
            AppColors.white,
            AppColors.pink,
            AppColors.pink,
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: SafeArea(
        child: likedSongsAsync.when(
          loading: () => const AppLoader(),
          error: (e, st) => Center(
            child: Text(
              'Failed to load favorites',
              style: TextStyle(color: Colors.red),
            ),
          ),
          data: (songs) {
            return Padding(
              padding: EdgeInsets.all(3.0.r),
              child: LiquidGlass(
                glassContainsChild: false,
                settings: LiquidGlassSettings(
                  thickness: 8,
                  lightAngle: 40,
                  // lightness: 1.3,
                ),
                shape: LiquidRoundedRectangle(
                  borderRadius: Radius.circular(18.r),
                ),
                child: songs.isEmpty
                    ? Center(
                        child: Glassify(
                          child: Text(
                            "No favorites yet 😢",
                            style: TextStyle(
                              fontSize: 20.sp,
                              color: AppColors.subfont,
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          SizedBox(height: 10.h),
                          SizedBox(height: 30.h),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Glassify(
                                child: Text(
                                  "Favorites",
                                  style: TextStyle(
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.subfont,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30.h),

                          Expanded(child: Text('Failed to load user')),

                          ListView.builder(
                            itemCount: songs.length,
                            itemBuilder: (context, index) {
                              final song = songs[index];
                              return InkWell(
                                onTap: () async {
                                  final artist = await getArtistFromSongId(
                                    song.id,
                                  );
                                  context.push(
                                    '/songdetails',
                                    extra: {
                                      'song': song,
                                      'artist': artist,
                                      'userId': userAsync.uid,
                                      'artistSongs': songs,
                                    },
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(8.0.r),
                                  child: LiquidGlass(
                                    shape: LiquidRoundedRectangle(
                                      borderRadius: Radius.circular(10.r),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                            vertical: 4.h,
                                          ),
                                          child: Songitem(
                                            title: song.title,
                                            imageUrl: song.coverUrl,
                                            songId: song.id,
                                            artistId: song.artistId,
                                            userId: userAsync!.uid,
                                            audioUrl: song.audioUrl,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}
