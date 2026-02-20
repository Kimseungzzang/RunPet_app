import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runpet_app/app/runpet_home_shell.dart';
import 'package:runpet_app/screens/login_screen.dart';
import 'package:runpet_app/state/providers.dart';
import 'package:runpet_app/theme/app_theme.dart';

class RunpetApp extends ConsumerWidget {
  const RunpetApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    return MaterialApp(
      title: 'RunPet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: authState.isAuthenticated ? const RunpetHomeShell() : const LoginScreen(),
    );
  }
}
