import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/ArtistCard.dart';
import 'package:flutter_application_1/features/home/home_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'app_loader.dart';

class Artistsection extends ConsumerWidget {
  const Artistsection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artists = ref.watch(artistProvider);
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        children: [
          const SizedBox(height: 8),
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
                      onTap: () =>
                          context.push('/artistdetails', extra: artist),
                      child: Artistcard(
                        imageUrl: artist.imageUrl,
                        name: artist.name,
                      ),
                    );
                  },
                ),
                error: (eror, stack) {
                  return Text('error');
                },
                loading: () => const AppLoader(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
