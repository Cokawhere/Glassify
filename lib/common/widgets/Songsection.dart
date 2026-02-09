import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/songCard.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_renderer/experimental.dart';
import 'app_loader.dart';
import '../../features/Auth/controller.dart';
import '../../features/home/home_services.dart';
import '../../features/notifcation audio state/model_song.dart';

class Songsection extends ConsumerWidget {
  final String sectionName;
  final FutureProvider<List<Songg>> songsProvider;
  const Songsection({
    super.key,
    required this.sectionName,
    required this.songsProvider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songs = ref.watch(songsProvider);
    final userAsync = ref.watch(currentUser);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 8.w),
              Glassify(
                child: Text(
                  sectionName,
                  style: TextStyle(
                    fontSize: 23.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Glassify(
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_forward_rounded),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 40.h),
          SizedBox(
            height: 195.h,
            child: songs.when(
              data: (songs) => ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  final song = songs[index];              
                      final currentUserId = userAsync?.uid ?? '';
                      return InkWell(
                        onTap: () async {
                          final selectedSong = songs[index];

                          final artist = await getArtistFromSongId(song.id);
                          context.push(
                            '/songdetails',
                            extra: {
                              'song': selectedSong,
                              'artist': artist,
                              'userId': currentUserId,
                              'artistSongs': songs,
                            },
                          );
                        },
                        child: Songcard(
                          artistId: song.artistId,
                          imageUrl: song.coverUrl,
                          songName: song.title,
                        ),
                      );
                    },
                  
              ),
              error: (eror, stack) {
                return const Text('faild to fetch songs data');
              },
              loading: () => const AppLoader(),
            ),
          ),
        ],
      ),
    );
  }
}
