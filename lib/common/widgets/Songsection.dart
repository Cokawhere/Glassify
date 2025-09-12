import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/songCard.dart';
import 'package:flutter_application_1/features/home/home_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class Song {
  final String imageUrl;
  final String songName;
  final String artistName;
  
  Song({
    required this.imageUrl,
    required this.songName,
    required this.artistName,
  });
}

class Songsection extends ConsumerWidget {
  final String sectionName;
  const Songsection({super.key, required this.sectionName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songs = ref.watch(newReleasesFutureProvider);
    return Padding(
      padding: const EdgeInsets.only(right: 8,left: 8,bottom: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 8),
              Glassify(
                child: Text(
                  sectionName,
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900),
                ),
              ),
              SizedBox(width: 158),
              Row(
                children: [
                  Glassify(
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.arrow_forward_rounded),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(
            height: 195,
            child: songs.when(
              data: (songs) => ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  final song = songs[index];
                  return Songcard(
                    artistName: song.artistName,
                    imageUrl: song.imageUrl,
                    songName: song.songName,
                  );
                },
              ),
              error: (eror, Stack) {
                return Text('faild to fetch songs data');
              },
              loading: () => CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
