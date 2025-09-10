import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/ArtistSection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import '../../common/styles/colors.dart';
import '../Auth/controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userStream = ref.watch(userStreamProvider);

    return Scaffold(
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
            padding: const EdgeInsets.all(6.0),
            child: LiquidGlass(
              glassContainsChild: true,
              shape: LiquidRoundedRectangle(borderRadius: Radius.circular(18)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            userStream.value?.imageUrl ??
                                "https://i.pinimg.com/1200x/10/d3/eb/10d3eb63d65c49f45148b61142d9b22d.jpg",
                          ),
                        ),
                      ),
                      SizedBox(width: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Glassify(
                            child: Text(
                              'Hi ${userStream.value?.name ?? ""}',
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 129),

                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Glassify(
                              child: Icon(Icons.search, size: 35),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Artistsection(sectionName: "Artists"),

                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () async {
                      await ref.read(authController).signout(context);
                    },
                    child: const Text("sign out"),
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
