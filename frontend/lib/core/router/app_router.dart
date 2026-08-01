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
import '../../shared/seo/titled_page.dart';

/// Central route table for the whole student application flow.
///
/// Every route is wrapped in [TitledPage] with its own distinct,
/// search-relevant title — Flutter web otherwise ships one static
/// `<title>` for every route.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'landing',
      builder: (context, state) => const TitledPage(
        title: 'MBBS Abroad Admissions 2026 | Sree Consultancy',
        child: LandingScreen(),
      ),
    ),
    GoRoute(
      path: '/countries',
      name: 'countries',
      builder: (context, state) => const TitledPage(
        title: 'Choose Your MBBS Study-Abroad Country | Sree Consultancy',
        child: CountrySelectionScreen(),
      ),
    ),
    GoRoute(
      path: '/colleges',
      name: 'colleges',
      builder: (context, state) => const TitledPage(
        title: 'NMC-Approved MBBS Colleges Abroad | Sree Consultancy',
        child: CollegeSelectionScreen(),
      ),
    ),
    GoRoute(
      path: '/details',
      name: 'details',
      builder: (context, state) => const TitledPage(
        title: 'Start Your MBBS Abroad Application | Sree Consultancy',
        child: DetailsScreen(),
      ),
    ),
    GoRoute(
      path: '/review',
      name: 'review',
      builder: (context, state) => const TitledPage(
        title: 'Review Your Application | Sree Consultancy',
        child: ReviewScreen(),
      ),
    ),
    GoRoute(
      path: '/success',
      name: 'success',
      builder: (context, state) => const TitledPage(
        title: 'Application Received | Sree Consultancy',
        child: SuccessScreen(),
      ),
    ),

    // ── Admin panel (staff only, behind login; kept out of search via
    // robots.txt + web/_headers noindex — titles below are for staff only) ──
    GoRoute(
      path: '/admin/login',
      name: 'adminLogin',
      builder: (context, state) => const TitledPage(
        title: 'Admin Login | Sree Consultancy',
        child: AdminLoginScreen(),
      ),
    ),
    GoRoute(
      path: '/admin',
      name: 'adminDashboard',
      builder: (context, state) => const TitledPage(
        title: 'Admin Dashboard | Sree Consultancy',
        child: AdminDashboardScreen(),
      ),
    ),
    GoRoute(
      path: '/admin/colleges',
      name: 'adminColleges',
      builder: (context, state) => const TitledPage(
        title: 'Manage Colleges | Sree Consultancy',
        child: AdminCollegesScreen(),
      ),
    ),

    // ── Legal ──
    GoRoute(
      path: '/privacy',
      name: 'privacy',
      builder: (context, state) => const TitledPage(
        title: 'Privacy Policy | Sree Consultancy',
        child: PrivacyPolicyScreen(),
      ),
    ),
  ],
);
