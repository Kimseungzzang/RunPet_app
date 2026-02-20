import 'package:flutter/material.dart';
import 'package:runpet_app/screens/home_screen.dart';
import 'package:runpet_app/screens/pet_screen.dart';
import 'package:runpet_app/screens/report_screen.dart';
import 'package:runpet_app/screens/run_result_screen.dart';
import 'package:runpet_app/screens/running_screen.dart';
import 'package:runpet_app/screens/shop_screen.dart';

class RunpetHomeShell extends StatefulWidget {
  const RunpetHomeShell({super.key});

  @override
  State<RunpetHomeShell> createState() => _RunpetHomeShellState();
}

class _RunpetHomeShellState extends State<RunpetHomeShell> {
  int _tabIndex = 0;
  bool _isRunning = true;

  void _moveTab(int index) {
    setState(() {
      _tabIndex = index;
    });
  }

  void _openShop() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ShopScreen()),
    );
  }

  void _openRunResult() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RunResultScreen(
          onConfirm: () => Navigator.of(context).pop(),
          onWatchRewardAd: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('보상형 광고 연결 예정(MVP 단계)')),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomeScreen(
        onRunStart: () => _moveTab(1),
        onGoPet: () => _moveTab(2),
      ),
      RunningScreen(
        isRunning: _isRunning,
        onToggleRunning: () => setState(() => _isRunning = !_isRunning),
        onFinish: _openRunResult,
      ),
      PetScreen(onGoShop: _openShop),
      const ReportScreen(),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('RunPet')),
      body: IndexedStack(index: _tabIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: _moveTab,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: '홈'),
          NavigationDestination(icon: Icon(Icons.directions_run), label: '러닝'),
          NavigationDestination(icon: Icon(Icons.pets_outlined), label: '펫'),
          NavigationDestination(icon: Icon(Icons.bar_chart_outlined), label: '리포트'),
        ],
      ),
    );
  }
}

