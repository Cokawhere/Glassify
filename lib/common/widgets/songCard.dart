import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/ArtistDetailPage%D8%8C/artistdetailscontroller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../styles/colors.dart';

class Songcard extends ConsumerWidget {
  final String imageUrl;
  final String songName;
  final String artistId;

  const Songcard({
    super.key,
    required this.artistId,
    required this.imageUrl,
    required this.songName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artistFuture = ref.watch(artistDetailsProvider(artistId));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Colors.grey.shade200,
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.network(
              imageUrl,
              // width: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
            ),
          ),

          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                songName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.subfont,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              artistFuture.when(
                data: (artist) => Text(
                  artist.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.font,
                  ),
                ),
                loading: () => const SizedBox(
                  width: 50,
                  height: 10,
                  child: LinearProgressIndicator(),
                ),
                error: (e, st) => const Text(
                  'N/A',
                  style: TextStyle(fontSize: 14, color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
