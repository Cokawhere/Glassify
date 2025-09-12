import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/styles/colors.dart';
import 'package:flutter_application_1/features/ArtistDetailPage%D8%8C/artistdetailscontroller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Songitem extends ConsumerStatefulWidget {
  final String title;
  final String artist;
  final String imageUrl;
  final String songId;
  final String artistId;
  final String userId;

  const Songitem({
    super.key,
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.songId,
    required this.artistId,
    required this.userId,
  });

  @override
  ConsumerState<Songitem> createState() => _SongitemState();
}

class _SongitemState extends ConsumerState<Songitem> {
  @override
  Widget build(BuildContext context) {
    final likeSongController = ref.watch(likeSongProvider);
    if (widget.userId.isEmpty || widget.songId.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 3, vertical: 6),
        child: Row(
          children: [Text('Invalid data', style: TextStyle(color: Colors.red))],
        ),
      );
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3, vertical: 6),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              print('wowow');
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.imageUrl),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          SizedBox(width: 4),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: InkWell(
                onTap: () {
                  print('wowow');
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.artist,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
          StreamBuilder<bool>(
            stream: ref
                .read(artistServicesProvider)
                .isSongLiked(widget.userId, widget.songId),
            builder: (context, snapshots) {
              final isLiked = snapshots.data ?? false;
              return IconButton(
                onPressed: () async {
                  await likeSongController.toggleLike(
                    isLiked: isLiked,
                    userId: widget.userId,
                    artistId: widget.artistId,
                    songId: widget.songId,
                  );
                },
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: AppColors.subfont,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
