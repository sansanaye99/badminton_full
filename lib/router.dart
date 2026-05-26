import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'providers/auth_provider.dart';

import 'models/activity.dart';

import 'screens/landing_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/main_shell.dart';

import 'screens/home_screen.dart';
import 'screens/news_screen.dart';
import 'screens/news_detail_screen.dart';
import 'screens/activities_screen.dart';
import 'screens/activity_detail_screen.dart';
import 'screens/tournaments_screen.dart';
import 'screens/tournament_detail_screen.dart';
import 'screens/tournament_register_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/ranking_screen.dart';
import 'screens/player_detail_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/about_screen.dart';

import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/admin_news_screen.dart';
import 'screens/admin/admin_activities_screen.dart';
import 'screens/admin/admin_tournaments_screen.dart';
import 'screens/admin/admin_members_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/landing',

    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final loc = state.matchedLocation;

      final isPublic =
          loc == '/login' ||
              loc == '/signup' ||
              loc == '/landing' ||
              loc == '/public-news' ||
              loc.startsWith('/public-news/') ||
              loc == '/public-tournaments' ||
              loc.startsWith('/public-tournaments/');

      if (!isLoggedIn && !isPublic) {
        return '/landing';
      }

      if (isLoggedIn &&
          (loc == '/login' || loc == '/signup' || loc == '/landing')) {
        return '/home';
      }

      return null;
    },

    errorBuilder: (context, state) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Page Not Found',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  state.error.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => context.go('/home'),
                  child: const Text('Go home'),
                ),
              ],
            ),
          ),
        ),
      );
    },

    routes: [
      // ── Public routes ─────────────────────────────────────────────

      GoRoute(
        path: '/landing',
        builder: (_, __) => const LandingScreen(),
      ),

      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),

      GoRoute(
        path: '/signup',
        builder: (_, __) => const SignupScreen(),
      ),

      // ── Public news ───────────────────────────────────────────────

      GoRoute(
        path: '/public-news',
        builder: (_, __) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Club news',
              style: TextStyle(
                color: Color(0xFFE87EA1),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            leading: Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () => GoRouter.of(ctx).go('/landing'),
              ),
            ),
          ),
          body: const NewsScreen(),
        ),
      ),

      GoRoute(
        path: '/public-news/:id',
        builder: (_, state) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'News',
              style: TextStyle(
                color: Color(0xFFE87EA1),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            leading: Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () => GoRouter.of(ctx).go('/public-news'),
              ),
            ),
          ),
          body: NewsDetailScreen(
            newsId: state.pathParameters['id']!,
          ),
        ),
      ),

      // ── Public tournaments ────────────────────────────────────────

      GoRoute(
        path: '/public-tournaments',
        builder: (_, __) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Tournaments',
              style: TextStyle(
                color: Color(0xFFE87EA1),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            leading: Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () => GoRouter.of(ctx).go('/landing'),
              ),
            ),
          ),
          body: const TournamentsScreen(),
        ),
      ),

      GoRoute(
        path: '/public-tournaments/:id',
        builder: (_, state) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Tournament details',
              style: TextStyle(
                color: Color(0xFFE87EA1),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            leading: Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () => GoRouter.of(ctx).go('/public-tournaments'),
              ),
            ),
          ),
          body: TournamentDetailScreen(
            id: state.pathParameters['id']!,
          ),
        ),
      ),

      // ── Member routes ─────────────────────────────────────────────

      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (_, __) => const HomeScreen(),
          ),

          // News
          GoRoute(
            path: '/news',
            builder: (_, __) => const NewsScreen(),
          ),

          GoRoute(
            path: '/news/:id',
            builder: (_, state) => NewsDetailScreen(
              newsId: state.pathParameters['id']!,
            ),
          ),

          // Activities
          GoRoute(
            path: '/activities',
            builder: (_, __) => const ActivitiesScreen(),
          ),

          GoRoute(
            path: '/activities/:id',
            builder: (_, state) {
              final activity = state.extra as Activity?;

              if (activity == null) {
                return const Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                    child: Text(
                      'Activity not found',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                );
              }

              return ActivityDetailScreen(activity: activity);
            },
          ),

          // Tournaments
          GoRoute(
            path: '/tournaments',
            builder: (_, __) => const TournamentsScreen(),
          ),

          GoRoute(
            path: '/tournaments/:id',
            builder: (_, state) => TournamentDetailScreen(
              id: state.pathParameters['id']!,
            ),
          ),

          GoRoute(
            path: '/tournaments/:id/register',
            builder: (_, state) => TournamentRegisterScreen(
              tournamentId: state.pathParameters['id']!,
            ),
          ),

          // Booking
          GoRoute(
            path: '/booking',
            builder: (_, __) => const BookingScreen(),
          ),

          // Ranking
          GoRoute(
            path: '/ranking',
            builder: (_, __) => const RankingScreen(),
          ),

          GoRoute(
            path: '/ranking/:id',
            builder: (_, state) => PlayerDetailScreen(
              id: state.pathParameters['id']!,
            ),
          ),

          // Settings
          GoRoute(
            path: '/settings',
            builder: (_, __) => const SettingsScreen(),
          ),

          // About
          GoRoute(
            path: '/about',
            builder: (_, __) => const AboutScreen(),
          ),

          // Admin
          GoRoute(
            path: '/admin',
            builder: (_, __) => const AdminDashboardScreen(),
          ),

          GoRoute(
            path: '/admin/news',
            builder: (_, __) => const AdminNewsScreen(),
          ),

          GoRoute(
            path: '/admin/activities',
            builder: (_, __) => const AdminActivitiesScreen(),
          ),

          GoRoute(
            path: '/admin/tournaments',
            builder: (_, __) => const AdminTournamentsScreen(),
          ),

          GoRoute(
            path: '/admin/members',
            builder: (_, __) => const AdminMembersScreen(),
          ),
        ],
      ),
    ],
  );
});