import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';
import 'providers/theme_provider.dart';
import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAuth.instance.setSettings(
    appVerificationDisabledForTesting: true,
  );

  runApp(
    const ProviderScope(
      child: BadmintonApp(),
    ),
  );
}

class BadmintonApp extends ConsumerWidget {
  const BadmintonApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    // NOW themeProvider returns ThemeData
    final theme = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'Tampere Badminton Club',
      debugShowCheckedModeBanner: false,

      // USE ONLY THIS
      theme: theme,

      routerConfig: router,
    );
  }
}