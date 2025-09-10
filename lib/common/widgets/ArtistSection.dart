import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/ArtistCard.dart';
import 'package:flutter_application_1/features/home/home_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class Artist {
  final String imageUrl;
  final String name;
  Artist({required this.imageUrl, required this.name});
}

class Artistsection extends ConsumerWidget {
  final String sectionName;
  const Artistsection({super.key, required this.sectionName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artists = ref.watch(artistProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(height: 10),
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
              SizedBox(width: 225),
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

          LiquidGlass(
            glassContainsChild: false,
            shape: LiquidRoundedRectangle(borderRadius: Radius.circular(40)),
            child: SizedBox(
              height: 118,
              child: artists.when(
                data: (artists) => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: artists.length,
                  itemBuilder: (context, index) {
                    final artist = artists[index];
                    return Artistcard(
                      imageUrl: artist.imageUrl,
                      name: artist.name,
                    );
                  },
                ),
                error: (eror, Stack) {
                  print("$eror");
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
