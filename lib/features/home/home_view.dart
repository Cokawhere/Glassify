import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/ArtistSection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import '../../common/styles/colors.dart';
import '../../common/widgets/Songsection.dart';
import '../Auth/controller.dart';
import 'home_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: false,
      body: Container(
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
          // bottom: false,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: LiquidGlass(
              glassContainsChild: true,
              settings: LiquidGlassSettings(
                thickness: 8,
                lightAngle: 40,
                lightness: 1.3,
              ),
              shape: LiquidRoundedRectangle(borderRadius: Radius.circular(18)),

              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Glassify(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: Text(
                            'Glassify',
                            style: GoogleFonts.tajawal(
                              fontSize: 35,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Artistsection(),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Songsection(
                            sectionName: 'New Releses',
                            songsProvider: newReleasesFutureProvider,
                          ),
                          Songsection(
                            sectionName: 'All Songs',
                            songsProvider: alphabeticalSongsProvider,
                          ),

                          SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
