import 'package:flutter/material.dart';
import 'package:runpet_app/app/runpet_home_shell.dart';
import 'package:runpet_app/theme/app_theme.dart';

class RunpetApp extends StatelessWidget {
  const RunpetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RunPet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const RunpetHomeShell(),
    );
  }
}

