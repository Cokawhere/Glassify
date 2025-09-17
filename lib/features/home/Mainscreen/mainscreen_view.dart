import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/styles/colors.dart';
import 'package:flutter_application_1/common/widgets/CurrentsongWidget.dart';
import 'package:flutter_application_1/common/widgets/app_loader.dart';
import 'package:flutter_application_1/features/Auth/controller.dart';
import 'package:flutter_application_1/features/favorites/favorites_view.dart';
import 'package:flutter_application_1/features/home/home_view.dart';
import 'package:flutter_application_1/features/settings/settings_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../notifcation audio state/controller.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
  }

  void _requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentSong = ref.watch(currentSongProvider);
    final userAsync = ref.watch(userStreamProvider);
    final isSongPlaying = currentSong != null;
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: userAsync.when(
        data: (user) {
          // IndexedStack preserves the state of each page when switching tabs.
          return IndexedStack(
            index: _currentIndex,
            children: const [HomeScreen(), FavoritesScreen(), SettingsScreen()],
          );
        },
        loading: () => const AppLoader(),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSongPlaying)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: CurrentSongWidget(
                currentUserId: userAsync.value?.uid ?? '',
              ),
            ),
          BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            backgroundColor: AppColors.pink.withOpacity(0.8),
            selectedItemColor: AppColors.white,
            unselectedItemColor: AppColors.subfont,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                activeIcon: Icon(Icons.favorite),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings),
                label: '',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
