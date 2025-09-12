import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/ArtistCard.dart';
import 'package:flutter_application_1/features/home/home_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

import '../../core/routing/app_router.dart';

class Artist {
  final String imageUrl;
  final String name;
  final String id;
  Artist({required this.imageUrl, required this.name, required this.id});
}

class Artistsection extends ConsumerWidget {
  final String sectionName;
  const Artistsection({super.key, required this.sectionName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artists = ref.watch(artistProvider);
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [SizedBox(width: 8), SizedBox(height: 8)],
          ),
          LiquidGlass(
            glassContainsChild: false,
            shape: LiquidRoundedRectangle(borderRadius: Radius.circular(30)),
            child: SizedBox(
              height: 110,
              child: artists.when(
                data: (artists) => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: artists.length,
                  itemBuilder: (context, index) {
                    final artist = artists[index];
                    return InkWell(
                      onTap: () {
                        ref.read(selectedArtistProvider.notifier).state =
                            artist;
                        context.go('/artistdetails');

                        // context.go('/artistdetails', extra: artist);

                      },
                      child: Artistcard(
                        imageUrl: artist.imageUrl,
                        name: artist.name,
                      ),
                    );
                  },
                ),
                error: (eror, Stack) {
                  print("$eror");
                  return Text('error');
                },
                loading: () => CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
