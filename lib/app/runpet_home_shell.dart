import 'package:flutter/material.dart';
import 'package:runpet_app/config/app_config.dart';
import 'package:runpet_app/models/payment_model.dart';
import 'package:runpet_app/models/pet_model.dart';
import 'package:runpet_app/screens/home_screen.dart';
import 'package:runpet_app/screens/pet_screen.dart';
import 'package:runpet_app/screens/report_screen.dart';
import 'package:runpet_app/screens/run_result_screen.dart';
import 'package:runpet_app/screens/running_screen.dart';
import 'package:runpet_app/screens/shop_screen.dart';
import 'package:runpet_app/services/runpet_api_client.dart';

class RunpetHomeShell extends StatefulWidget {
  const RunpetHomeShell({super.key});

  @override
  State<RunpetHomeShell> createState() => _RunpetHomeShellState();
}

class _RunpetHomeShellState extends State<RunpetHomeShell> {
  final RunpetApiClient _api = RunpetApiClient(baseUrl: AppConfig.apiBaseUrl);
  final String _userId = 'user_001';

  int _tabIndex = 0;
  bool _isRunning = true;
  bool _isBusy = false;
  String? _activeRunId;
  PetModel? _pet;

  @override
  void initState() {
    super.initState();
    _loadPet();
  }

  Future<void> _loadPet() async {
    try {
      final pet = await _api.getPet(userId: _userId);
      if (!mounted) return;
      setState(() => _pet = pet);
    } catch (e) {
      _showError('Failed to load pet: $e');
    }
  }

  void _moveTab(int index) {
    setState(() => _tabIndex = index);
  }

  Future<void> _startRunSession() async {
    setState(() => _isBusy = true);
    try {
      final start = await _api.startRun(userId: _userId);
      if (!mounted) return;
      setState(() {
        _activeRunId = start.runId;
        _tabIndex = 1;
      });
    } catch (e) {
      _showError('Failed to start run: $e');
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _finishRunSession() async {
    final runId = _activeRunId;
    if (runId == null) {
      _showError('Start a run first.');
      return;
    }

    setState(() => _isBusy = true);
    try {
      final result = await _api.finishRun(
        runId: runId,
        distanceKm: 2.14,
        durationSec: 1122,
        avgPaceSec: 312,
        calories: 178,
      );

      final pet = await _api.getPet(userId: _userId);
      if (!mounted) return;

      setState(() {
        _activeRunId = null;
        _pet = pet;
      });

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => RunResultScreen(
            result: result,
            onConfirm: () => Navigator.of(context).pop(),
            onWatchRewardAd: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reward ad integration pending')),
              );
            },
          ),
        ),
      );
    } catch (e) {
      _showError('Failed to finish run: $e');
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _equipSampleHat() async {
    setState(() => _isBusy = true);
    try {
      final pet = await _api.equipPet(
        userId: _userId,
        slotType: 'hat',
        itemId: 'hat_leaf_cap',
      );
      if (!mounted) return;
      setState(() => _pet = pet);
    } catch (e) {
      _showError('Failed to equip item: $e');
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<PaymentVerifyResponseModel> _purchase(String productId) {
    return _api.verifyPayment(
      userId: _userId,
      productId: productId,
      platform: 'android',
      transactionId: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      receiptToken: 'sample-receipt-token-12345',
    );
  }

  void _openShop() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ShopScreen(
          isBusy: _isBusy,
          onPurchase: _purchase,
        ),
      ),
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomeScreen(
        pet: _pet,
        onRunStart: _startRunSession,
        onGoPet: () => _moveTab(2),
      ),
      RunningScreen(
        isRunning: _isRunning,
        hasActiveRun: _activeRunId != null,
        isBusy: _isBusy,
        onStartRun: _startRunSession,
        onToggleRunning: () => setState(() => _isRunning = !_isRunning),
        onFinish: _finishRunSession,
      ),
      PetScreen(
        pet: _pet,
        isBusy: _isBusy,
        onEquipHat: _equipSampleHat,
        onGoShop: _openShop,
      ),
      const ReportScreen(),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('RunPet')),
      body: IndexedStack(index: _tabIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: _moveTab,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.directions_run), label: 'Running'),
          NavigationDestination(icon: Icon(Icons.pets_outlined), label: 'Pet'),
          NavigationDestination(icon: Icon(Icons.bar_chart_outlined), label: 'Report'),
        ],
      ),
    );
  }
}
