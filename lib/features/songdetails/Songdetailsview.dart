import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import '../../models/artist.dart';
import '../notifcation audio state/controller.dart';
import '../notifcation audio state/model_song.dart';
import 'cover_image_section.dart';
import 'like_button_row.dart';
import 'playback_controls.dart';

class SongDetailsView extends ConsumerStatefulWidget {
  final Songg song;
  final Artist artist;
  final String userId;
  final List<Songg> artistSongs;

  const SongDetailsView({
    super.key,
    required this.song,
    required this.artist,
    required this.artistSongs,
    required this.userId,
  });

  @override
  ConsumerState<SongDetailsView> createState() => _SongDetailsViewState();
}

class _SongDetailsViewState extends ConsumerState<SongDetailsView> {
  late Songg displayedSong;

  @override
  void initState() {
    super.initState();
    displayedSong = widget.song;

    final audioController = ref.read(audioControlerProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      audioController.prepareSong(displayedSong, widget.artistSongs);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(displayedSong.coverUrl, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: const Color.fromARGB(55, 62, 167, 139)),
          ),

          Padding(
            padding: const EdgeInsets.only(right: 7, left: 7, top: 40),
            child: LikeButtonRow(
              song: displayedSong,
              artist: widget.artist,
              userId: widget.userId,
            ),
          ),

          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 120),

                CoverImageSection(song: displayedSong, artist: widget.artist),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 30,
                  ),
                  child: LiquidGlass(
                    glassContainsChild: false,
                    shape: LiquidRoundedRectangle(
                      borderRadius: Radius.circular(40),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: PlaybackControls(
                        displayedSong: displayedSong,
                        queue: widget.artistSongs,
                        onSongChanged: (song) {
                          setState(() {
                            displayedSong = song;
                          });
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
