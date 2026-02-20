import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runpet_app/app/runpet_home_shell.dart';
import 'package:runpet_app/screens/login_screen.dart';
import 'package:runpet_app/state/providers.dart';
import 'package:runpet_app/theme/app_theme.dart';

class RunpetApp extends ConsumerStatefulWidget {
  const RunpetApp({super.key});

  @override
  ConsumerState<RunpetApp> createState() => _RunpetAppState();
}

class _RunpetAppState extends ConsumerState<RunpetApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(authControllerProvider.notifier).initialize());
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    return MaterialApp(
      title: 'RunPet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: !authState.isInitialized
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : (authState.isAuthenticated ? const RunpetHomeShell() : const LoginScreen()),
    );
  }
}
