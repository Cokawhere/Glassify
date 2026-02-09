import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/ArtistSection.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_glass_renderer/experimental.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import '../../common/styles/colors.dart';
import '../../common/widgets/Songsection.dart';
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
          child: Padding(
            padding: EdgeInsets.only(left: 6.r, right: 6.r),
            child: LiquidGlass(
              glassContainsChild: true,
              settings: LiquidGlassSettings(thickness: 8, lightAngle: 40),
              shape: LiquidRoundedRectangle(
                borderRadius: Radius.circular(18.r),
              ),

              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Glassify(
                        child: Padding(
                          padding: EdgeInsets.only(top: 1.h),
                          child: Text(
                            'Glassify',
                            style: GoogleFonts.tajawal(
                              fontSize: 35.sp,
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

                          SizedBox(height: 100.h),
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
