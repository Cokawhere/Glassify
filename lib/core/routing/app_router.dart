import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/Auth/controller.dart';
import '../../features/auth/view/login_view.dart';
import '../../features/auth/view/signup_view.dart';
import '../../features/home/home_view.dart';

GoRouter createRouter(WidgetRef ref) {
  final userStream = ref.watch(userStreamProvider);
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    ],
    redirect: (context, state) {
      final currentPath = state.uri.toString();
      print('Redirect: user=$userStream, currentPath=$currentPath');
      return userStream.when(
        data: (user) {
          if (user == null && currentPath == '/login' ||
              currentPath == '/signup') {
            return null;
          }
          if (user == null &&
              currentPath != '/login' &&
              currentPath != '/signup') {
            return '/login';
          }
          if (user == null) {
            return '/login';
          }
          if (currentPath == '/login' ||
              currentPath == '/signup') {
            return '/home';
          }

          return null;
        },
        loading: () => null,
        error: (error, stack) => '/login',
      );
    },
  );
}
