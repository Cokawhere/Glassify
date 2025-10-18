import 'package:audio_service/audio_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/app_lifecycle_handler.dart';
import 'core/routing/app_router.dart';
import 'features/notifcation audio state/audio_handler.dart';
import 'firebase_options.dart';

late final AudioHandler audioHandler;

Future<void> initializeServices() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  audioHandler = await initAudioService();
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeServices().then((_) {
    runApp(const ProviderScope(child: MyApp()));
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // تهيئة ScreenUtil هنا
    return ScreenUtilInit(
      designSize: const Size(375, 812), // ضعي هنا أبعاد التصميم الذي تعملين عليه
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return AppLifecycleHandler(
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            restorationScopeId: 'app',
            routerConfig: createRouter(ref),
          ),
        );
      },
    );
  }
}
