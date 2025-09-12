import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/favorites/favorites_view.dart';
import 'package:flutter_application_1/features/home/home_view.dart';
import 'package:flutter_application_1/features/settings/settings_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/styles/colors.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: _pages[_currentIndex],
      bottomNavigationBar: SizedBox(
        height: 79,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),

            child: Container(
              color: Colors.transparent,
              child: BottomAppBar(
                color: Colors.transparent,
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  currentIndex: _currentIndex,
                  selectedItemColor: AppColors.subfont,
                  unselectedItemColor: AppColors.font,
                  selectedFontSize: 0,
                  // unselectedFontSize: 0,
                  // showSelectedLabels: false,
                  // showUnselectedLabels: false,
                  onTap: (index) {  
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  items: const [
                    BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.favorite),
                      label: "",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      label: "",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
