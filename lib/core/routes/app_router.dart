import 'package:go_router/go_router.dart';
import '../../presentation/pages/splash_page.dart';
import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/bookmark_page.dart';
import '../../presentation/pages/product_detail_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/bookmark',
      name: 'bookmark',
      builder: (context, state) => const BookmarkPage(),
    ),
    GoRoute(
      path: '/product/:id',
      name: 'product_detail',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return ProductDetailPage(productId: id);
      },
    ),
  ],
);