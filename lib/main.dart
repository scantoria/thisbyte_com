import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';
import 'services/analytics_service.dart';
import 'screens/home_screen.dart';
import 'screens/services_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/privacy_screen.dart';
import 'utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await AnalyticsService.init();

  runApp(const MyApp());
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        AnalyticsService.logPageView('Home', 'HomeScreen');
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: '/services',
      builder: (context, state) {
        AnalyticsService.logPageView('Services', 'ServicesScreen');
        return const ServicesScreen();
      },
    ),
    GoRoute(
      path: '/contact',
      builder: (context, state) {
        AnalyticsService.logPageView('Contact', 'ContactScreen');
        return const ContactScreen();
      },
    ),
    GoRoute(
      path: '/privacy',
      builder: (context, state) {
        AnalyticsService.logPageView('Privacy', 'PrivacyScreen');
        return const PrivacyScreen();
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ThisByte, LLC',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
