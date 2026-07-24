import 'package:go_router/go_router.dart';

import '../../features/admin/admin_colleges_screen.dart';
import '../../features/admin/admin_dashboard_screen.dart';
import '../../features/admin/admin_login_screen.dart';
import '../../features/legal/privacy_policy_screen.dart';
import '../../features/college_selection/college_selection_screen.dart';
import '../../features/country_selection/country_selection_screen.dart';
import '../../features/details/details_screen.dart';
import '../../features/landing/landing_screen.dart';
import '../../features/review/review_screen.dart';
import '../../features/success/success_screen.dart';

/// Central route table for the whole student application flow.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'landing',
      builder: (context, state) => const LandingScreen(),
    ),
    GoRoute(
      path: '/countries',
      name: 'countries',
      builder: (context, state) => const CountrySelectionScreen(),
    ),
    GoRoute(
      path: '/colleges',
      name: 'colleges',
      builder: (context, state) => const CollegeSelectionScreen(),
    ),
    GoRoute(
      path: '/details',
      name: 'details',
      builder: (context, state) => const DetailsScreen(),
    ),
    GoRoute(
      path: '/review',
      name: 'review',
      builder: (context, state) => const ReviewScreen(),
    ),
    GoRoute(
      path: '/success',
      name: 'success',
      builder: (context, state) => const SuccessScreen(),
    ),

    // ── Admin panel (staff only, behind login) ──
    GoRoute(
      path: '/admin/login',
      name: 'adminLogin',
      builder: (context, state) => const AdminLoginScreen(),
    ),
    GoRoute(
      path: '/admin',
      name: 'adminDashboard',
      builder: (context, state) => const AdminDashboardScreen(),
    ),
    GoRoute(
      path: '/admin/colleges',
      name: 'adminColleges',
      builder: (context, state) => const AdminCollegesScreen(),
    ),

    // ── Legal ──
    GoRoute(
      path: '/privacy',
      name: 'privacy',
      builder: (context, state) => const PrivacyPolicyScreen(),
    ),
  ],
);
