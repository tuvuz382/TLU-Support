import 'package:go_router/go_router.dart';
import 'go_router_refresh_change.dart';
import 'app_routes.dart';

// Features - Auth
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';

// Features - Home
import '../../features/home/presentation/pages/home_page.dart';

// Features - Other
import '../../features/schedule/presentation/pages/schedule_page.dart';
import '../../features/notes/presentation/pages/notes_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/personal_info_page.dart';
import '../../features/profile/presentation/pages/profile_selector_page.dart';
import '../../features/documents/presentation/pages/documents_page.dart';
import '../../features/documents/presentation/pages/document_detail_page.dart';

// Features - Notifications
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/notifications/presentation/pages/notification_detail_page.dart';
import '../../features/notifications/domain/entities/notification_item.dart';

// Features - Scholarship
import '../../features/scholarship/presentation/pages/scholarship_list_page.dart';
import '../../features/scholarship/presentation/pages/scholarship_detail_page.dart';
import '../../features/scholarship/presentation/pages/scholarship_registration_page.dart';
import '../../features/scholarship/presentation/pages/scholarship_registration_info_page.dart';
import '../../features/scholarship/presentation/pages/registered_scholarships_page.dart';

// Features - Support Request
import '../../features/support_request/presentation/pages/support_request_page.dart';
import '../../features/support_request/presentation/pages/support_request_detail_page.dart';
import '../../features/support_request/domain/repositories/support_request_repository.dart';
import '../../features/support_request/data/repositories/support_request_repository_impl.dart';
import '../../features/support_request/data/datasources/firebase_support_request_datasource.dart';

// Features - GPA
import '../../features/gpa/presentation/pages/gpa_page.dart';

// Features - Teacher
import '../../features/teacher/presentation/pages/teacher_list_page.dart';
import '../../features/teacher/presentation/pages/teacher_detail_page.dart';

// Features - Subject/Curriculum
import '../../features/subject/presentation/pages/curriculum_page.dart';
import '../../features/subject/presentation/pages/subject_detail_page.dart';
// Layout
import '../../core/presentation/layouts/main_layout.dart';

class AppGoRouter {
  static final AuthRepository _authRepository = AuthRepositoryImpl();
  static final SupportRequestRepository _supportRequestRepository =
      SupportRequestRepositoryImpl(FirebaseSupportRequestDataSource());

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
          return MainLayout(currentIndex: currentIndex, child: child);
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
          GoRoute(
            path: AppRoutes.personalInfo,
            builder: (context, state) => const PersonalInfoPage(),
          ),
          GoRoute(
            path: AppRoutes.profileSelector,
            builder: (context, state) => const ProfileSelectorPage(),
          ),
          GoRoute(
            path: AppRoutes.notifications,
            builder: (context, state) => const NotificationsPage(),
          ),
          GoRoute(
            path: AppRoutes.documents,
            builder: (context, state) => const DocumentsPage(),
          ),
          GoRoute(
            path: AppRoutes.documentDetail,
            builder: (context, state) {
              final document = state.extra;
              return DocumentDetailPage(document: document as dynamic);
            },
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
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              final scholarshipId = extra?['scholarshipId'] as String?;
              final scholarshipTitle = extra?['scholarshipTitle'] as String?;
              return ScholarshipDetailPage(
                scholarshipId: scholarshipId,
                scholarshipTitle: scholarshipTitle,
              );
            },
          ),
          GoRoute(
            path: AppRoutes.scholarshipRegistration,
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              final scholarshipId = extra?['scholarshipId'] as String?;
              final scholarshipTitle = extra?['scholarshipTitle'] as String?;
              return ScholarshipRegistrationPage(
                scholarshipId: scholarshipId,
                scholarshipTitle: scholarshipTitle,
              );
            },
          ),
          GoRoute(
            path: AppRoutes.scholarshipRegistrationInfo,
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>;
              return ScholarshipRegistrationInfoPage(
                scholarshipTitle: extra['scholarshipTitle'] as String,
                studentId: extra['studentId'] as String,
                fullName: extra['fullName'] as String,
                email: extra['email'] as String,
                dateOfBirth: extra['dateOfBirth'] as DateTime,
                classInfo: extra['class'] as String,
                major: extra['major'] as String,
                gpa: extra['gpa'] as String,
              );
            },
          ),
          GoRoute(
            path: AppRoutes.registeredScholarships,
            builder: (context, state) => const RegisteredScholarshipsPage(),
          ),
          GoRoute(
            path: AppRoutes.supportRequest,
            builder: (context, state) =>
                SupportRequestPage(repository: _supportRequestRepository),
          ),
          GoRoute(
            path: AppRoutes.supportRequestDetail,
            builder: (context, state) {
              final request = state.extra;
              return SupportRequestDetailPage(request: request as dynamic);
            },
          ),
          GoRoute(
            path: AppRoutes.gpa,
            builder: (context, state) => const GPAPage(),
          ),
          GoRoute(
            path: AppRoutes.teacherList,
            builder: (context, state) => const TeacherListPage(),
          ),
          GoRoute(
            path: AppRoutes.teacherDetail,
            builder: (context, state) {
              final teacher = state.extra;
              return TeacherDetailPage(teacher: teacher as dynamic);
            },
          ),
          GoRoute(
            path: AppRoutes.curriculum,
            builder: (context, state) => const CurriculumPage(),
          ),
          GoRoute(
            path: AppRoutes.subjectDetail,
            builder: (context, state) {
              final subject = state.extra;
              return SubjectDetailPage(subject: subject as dynamic);
            },
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final user = _authRepository.getCurrentUser();
      final loggedIn = user != null;
      final loggingIn = state.matchedLocation == AppRoutes.login;

      if (!loggedIn && !loggingIn) return AppRoutes.login;
      if (loggedIn && loggingIn) return AppRoutes.home;
      return null;
    },
    refreshListenable: GoRouterRefreshStream(
      _authRepository.user.map((user) => user != null),
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
