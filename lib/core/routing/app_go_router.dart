import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'go_router_refresh_change.dart';
import 'app_routes.dart';

// Features - Auth
import '../../features/auth/presentation/pages/login_page.dart';

// Features - Home
import '../../features/home/presentation/pages/home_page.dart';

// Features - Other
import '../../features/schedule/presentation/pages/schedule_page.dart';
import '../../features/notes/presentation/pages/notes_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/personal_info_page.dart';

// Features - Notifications
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/notifications/presentation/pages/notification_detail_page.dart';

// Features - Scholarship
import '../../features/scholarship/presentation/pages/scholarship_list_page.dart';
import '../../features/scholarship/presentation/pages/scholarship_detail_page.dart';
import '../../features/scholarship/presentation/pages/registered_scholarships_page.dart';

// Layout
import '../../core/presentation/layouts/main_layout.dart';

class AppGoRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          final currentIndex = _getCurrentIndex(state.matchedLocation);
          return MainLayout(
            currentIndex: currentIndex,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: AppRoutes.schedule,
            builder: (context, state) => const SchedulePage(),
          ),
          GoRoute(
            path: AppRoutes.notes,
            builder: (context, state) => const NotesPage(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.personalInfo,
        builder: (context, state) => const PersonalInfoPage(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationsPage(),
      ),
      GoRoute(
        path: AppRoutes.notificationDetail,
        builder: (context, state) {
          final notification = state.extra as NotificationItem?;
          return NotificationDetailPage(notification: notification!);
        },
      ),
      GoRoute(
        path: AppRoutes.scholarshipList,
        builder: (context, state) => const ScholarshipListPage(),
      ),
      GoRoute(
        path: AppRoutes.scholarshipDetail,
        builder: (context, state) => const ScholarshipDetailPage(),
      ),
      GoRoute(
        path: AppRoutes.registeredScholarships,
        builder: (context, state) => const RegisteredScholarshipsPage(),
      ),
    ],
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final loggedIn = user != null;
      final loggingIn = state.matchedLocation == AppRoutes.login;
      
      if (!loggedIn && !loggingIn) return AppRoutes.login;
      if (loggedIn && loggingIn) return AppRoutes.home;
      return null;
    },
    refreshListenable: GoRouterRefreshStream(
      FirebaseAuth.instance.authStateChanges(),
    ),
  );

  static int _getCurrentIndex(String location) {
    if (location == AppRoutes.home) return 0;
    if (location == AppRoutes.schedule) return 1;
    if (location == AppRoutes.notes) return 2;
    if (location == AppRoutes.profile) return 3;
    return 0;
  }
}
