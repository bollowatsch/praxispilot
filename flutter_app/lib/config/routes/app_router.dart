import 'package:PraxisPilot/config/routes/route_constants.dart';
import 'package:PraxisPilot/features/auth/presentation/pages/login_page.dart';
import 'package:PraxisPilot/features/auth/presentation/pages/signup_page.dart';
import 'package:PraxisPilot/features/home/presentation/pages/home_page.dart';
import 'package:PraxisPilot/features/onboarding/presentation/pages/commercial_info_page.dart';
import 'package:PraxisPilot/features/onboarding/presentation/pages/personal_info_page.dart';
import 'package:PraxisPilot/features/onboarding/presentation/pages/preferences_page.dart';
import 'package:PraxisPilot/features/patients/domain/entities/patient.dart';
import 'package:PraxisPilot/features/patients/presentation/pages/patient_detail_page.dart';
import 'package:PraxisPilot/features/patients/presentation/pages/patients_page.dart';
import 'package:PraxisPilot/features/patients/presentation/widgets/patient_form_dialog.dart';
import 'package:PraxisPilot/features/session_notes/presentation/pages/session_note_editor_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteConstants.login,
  debugLogDiagnostics: true,
  routes: [
    // auth
    GoRoute(
      path: RouteConstants.login,
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: RouteConstants.signup,
      name: 'signup',
      builder: (context, state) => const SignUpPage(),
    ),
    // home
    GoRoute(
      path: RouteConstants.dashboard,
      name: 'dashboard',
      builder: (context, state) => const Dashboard(),
    ),
    // onboarding
    GoRoute(
      path: RouteConstants.onboardingPersonalInfo,
      name: 'onboardingPersonalInfo',
      builder: (context, state) => const OnboardingPersonalInfoPage(),
    ),
    GoRoute(
      path: RouteConstants.onboardingCommercialInfo,
      name: 'onboardingCommercialInfo',
      builder: (context, state) => const OnboardingCommercialInfoPage(),
    ),
    GoRoute(
      path: RouteConstants.onboardingPreferences,
      name: 'onboardingPreferences',
      builder: (context, state) => const OnboardingPreferencesPage(),
    ),
    // patients
    GoRoute(
      path: RouteConstants.patients,
      name: 'patients',
      builder: (context, state) => const PatientsPage(),
    ),
    GoRoute(
      path: '/patients/new',
      name: 'newPatient',
      builder: (context, state) => const PatientFormDialog(),
    ),
    GoRoute(
      path: '/patients/:id',
      name: 'patientDetail',
      builder: (context, state) {
        final patientId = state.pathParameters['id']!;
        return PatientDetailPage(patientId: patientId);
      },
    ),
    GoRoute(
      path: '/patients/:id/edit',
      name: 'editPatient',
      builder: (context, state) {
        final patient = state.extra as Patient;
        return PatientFormDialog(patient: patient);
      },
    ),
    // session notes
    GoRoute(
      path: '/patients/:patientId/session-notes/new',
      name: 'newSessionNote',
      builder: (context, state) {
        final patientId = state.pathParameters['patientId']!;
        return SessionNoteEditorPage(patientId: patientId);
      },
    ),
    GoRoute(
      path: '/patients/:patientId/session-notes/:noteId',
      name: 'editSessionNote',
      builder: (context, state) {
        final patientId = state.pathParameters['patientId']!;
        final noteId = state.pathParameters['noteId']!;
        return SessionNoteEditorPage(
          patientId: patientId,
          noteId: noteId,
        );
      },
    ),
  ],
  // Redirect is executed before every navigation and is now used to guard
  // the app against unauthorized routes
  redirect: (BuildContext context, GoRouterState state) {
    final isAuthenticated = Supabase.instance.client.auth.currentUser != null;
    final target = state.matchedLocation;

    final isGoingToAuth =
        target.startsWith('/auth') ||
        target == RouteConstants.login ||
        target == RouteConstants.signup;

    final publicRoutes = [];
    final isPublicRoute = publicRoutes.contains(target);

    // redirect to login if unauthenticated
    if (!isAuthenticated && !isGoingToAuth && !isPublicRoute) {
      return RouteConstants.login;
    }
    // redirect to dashboard if already logged in
    if (isAuthenticated && isGoingToAuth) {
      return RouteConstants.dashboard;
    }
    // everything else, just redirect to wanted route
    return null;
  },
);
