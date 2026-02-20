import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runpet_app/models/payment_model.dart';
import 'package:runpet_app/models/pet_model.dart';
import 'package:runpet_app/screens/home_screen.dart';
import 'package:runpet_app/screens/pet_screen.dart';
import 'package:runpet_app/screens/report_screen.dart';
import 'package:runpet_app/screens/run_result_screen.dart';
import 'package:runpet_app/screens/running_screen.dart';
import 'package:runpet_app/screens/shop_screen.dart';
import 'package:runpet_app/state/providers.dart';

class RunpetHomeShell extends ConsumerStatefulWidget {
  const RunpetHomeShell({super.key});

  @override
  ConsumerState<RunpetHomeShell> createState() => _RunpetHomeShellState();
}

class _RunpetHomeShellState extends ConsumerState<RunpetHomeShell> {
  int _tabIndex = 0;
  PetModel? _pet;
  bool _petBusy = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadPet);
  }

  Future<void> _loadPet() async {
    try {
      final api = ref.read(apiClientProvider);
      final pet = await api.getPet(userId: kUserId);
      if (!mounted) return;
      setState(() => _pet = pet);
    } catch (e) {
      _showError('Failed to load pet: $e');
    }
  }

  Future<void> _startRunSession() async {
    await ref.read(runSessionControllerProvider.notifier).startRun();
    final runState = ref.read(runSessionControllerProvider);
    if (runState.errorMessage != null) _showError(runState.errorMessage!);
  }

  Future<void> _finishRunSession() async {
    final result = await ref.read(runSessionControllerProvider.notifier).finishRun();
    final runState = ref.read(runSessionControllerProvider);
    if (runState.errorMessage != null) {
      _showError(runState.errorMessage!);
      return;
    }
    if (result == null || !mounted) return;

    await _loadPet();
    if (!mounted) return;

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
  }

  Future<void> _equipSampleHat() async {
    setState(() => _petBusy = true);
    try {
      final api = ref.read(apiClientProvider);
      final pet = await api.equipPet(
        userId: kUserId,
        slotType: 'hat',
        itemId: 'hat_leaf_cap',
      );
      if (!mounted) return;
      setState(() => _pet = pet);
    } catch (e) {
      _showError('Failed to equip item: $e');
    } finally {
      if (mounted) setState(() => _petBusy = false);
    }
  }

  Future<PaymentVerifyResponseModel> _purchase(String productId) {
    final api = ref.read(apiClientProvider);
    return api.verifyPayment(
      userId: kUserId,
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
          isBusy: _petBusy,
          onPurchase: _purchase,
        ),
      ),
    );
  }

  void _showError(String message) {
    if (!mounted || message.isEmpty) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final runState = ref.watch(runSessionControllerProvider);

    final pages = <Widget>[
      HomeScreen(
        pet: _pet,
        onRunStart: () {
          _startRunSession();
          setState(() => _tabIndex = 1);
        },
        onGoPet: () => setState(() => _tabIndex = 2),
      ),
      RunningScreen(
        isRunning: runState.isTracking,
        hasActiveRun: runState.hasActiveRun,
        isBusy: runState.isBusy,
        distanceKm: runState.distanceKm,
        durationSec: runState.durationSec,
        avgPaceSec: runState.avgPaceSec,
        calories: runState.calories,
        onStartRun: _startRunSession,
        onToggleRunning: () => ref.read(runSessionControllerProvider.notifier).toggleTracking(),
        onFinish: _finishRunSession,
      ),
      PetScreen(
        pet: _pet,
        isBusy: _petBusy,
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
        onDestinationSelected: (index) => setState(() => _tabIndex = index),
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
