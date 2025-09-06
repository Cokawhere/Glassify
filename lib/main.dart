import 'package:audio_service/audio_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/Auth/controller.dart';
import 'features/Auth/login_view.dart';
import 'features/home/home_view.dart';
import 'features/notifcation audio state/audio_handler.dart';

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

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.refresh(userStreamProvider); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final userStream = ref.watch(userStreamProvider);

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          routerConfig: GoRouter(
            initialLocation: '/login',
            routes: [
              GoRoute(
                path: '/login',
                builder: (context, state) => const LoginScreen(),
              ),
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
            redirect: (context, state) {
              final user = userStream.value;
              if (user == null && state.uri.toString() != '/login') {
                return '/login';
              } else if (user != null && state.uri.toString() == '/login') {
                return '/home';
              }
              return null;
            },
          ),
        );
      },
    );
  }
}
