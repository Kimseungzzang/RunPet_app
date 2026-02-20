import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runpet_app/config/app_config.dart';
import 'package:runpet_app/models/friend_models.dart';
import 'package:runpet_app/models/pet_model.dart';
import 'package:runpet_app/models/shop_product.dart';
import 'package:runpet_app/screens/home_screen.dart';
import 'package:runpet_app/screens/pet_screen.dart';
import 'package:runpet_app/screens/report_screen.dart';
import 'package:runpet_app/screens/run_result_screen.dart';
import 'package:runpet_app/screens/running_screen.dart';
import 'package:runpet_app/screens/shop_screen.dart';
import 'package:runpet_app/services/in_app_purchase_service.dart';
import 'package:runpet_app/state/providers.dart';
import 'package:runpet_app/widgets/pet_avatar.dart';

class RunpetHomeShell extends ConsumerStatefulWidget {
  const RunpetHomeShell({super.key});

  @override
  ConsumerState<RunpetHomeShell> createState() => _RunpetHomeShellState();
}

class _RunpetHomeShellState extends ConsumerState<RunpetHomeShell> {
  late final PurchaseService _purchaseService;

  int _tabIndex = 0;
  PetModel? _pet;
  bool _petBusy = false;
  bool _purchaseBusy = false;
  bool _storeAvailable = false;
  String? _purchaseMessage;
  List<ShopProduct> _shopProducts = const [];
  bool _friendBusy = false;
  List<FriendModel> _friends = const [];
  List<FriendRequestModel> _incomingFriendRequests = const [];
  List<FriendRequestModel> _outgoingFriendRequests = const [];
  List<FriendSearchUserModel> _friendSearchResults = const [];

  @override
  void initState() {
    super.initState();
    _purchaseService = ref.read(purchaseServiceProvider);
    Future.microtask(() async {
      await _loadPet();
      await _initStore();
    });
  }

  Future<void> _initStore() async {
    try {
      _purchaseService.startListening(
        onPurchasedOrRestored: _onPurchaseCompleted,
        onError: _showError,
      );
      _storeAvailable = await _purchaseService.isAvailable();
      if (!_storeAvailable) {
        setState(() {
          _purchaseMessage = 'Store not available on this device.';
        });
        return;
      }
      final products = await _purchaseService.loadProducts(AppConfig.iapProductIds);
      if (!mounted) return;
      setState(() => _shopProducts = products);
    } catch (e) {
      _showError('Failed to initialize store: $e');
    }
  }

  Future<void> _onPurchaseCompleted(PurchaseEvent detail) async {
    try {
      final api = ref.read(apiClientProvider);
      final productId = detail.productId;
      final token = detail.receiptToken;
      final transactionId = detail.transactionId;
      final platform = (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) ? 'ios' : 'android';

      final response = await api.verifyPayment(
        productId: productId,
        platform: platform,
        transactionId: transactionId,
        receiptToken: token,
      );

      if (!mounted) return;
      if (response.status != 'verified') {
        _showError('Purchase not verified: ${response.failureReason ?? response.status}');
        return;
      }
      setState(() {
        _purchaseMessage = 'Verified: ${response.productId}';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Purchase verified: ${response.productId}')),
      );
    } catch (e) {
      _showError('Purchase verification failed: $e');
    }
  }

  Future<void> _loadPet() async {
    try {
      final api = ref.read(apiClientProvider);
      final pet = await api.getPet();
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

  Future<void> _purchase(String productId) async {
    if (!_storeAvailable) {
      _showError('Store is unavailable.');
      return;
    }

    setState(() => _purchaseBusy = true);
    try {
      await _purchaseService.buy(productId);
      if (!mounted) return;
      setState(() => _purchaseMessage = 'Purchase requested for $productId');
    } catch (e) {
      _showError('Purchase request failed: $e');
    } finally {
      if (mounted) setState(() => _purchaseBusy = false);
    }
  }

  Future<void> _loadFriends() async {
    setState(() => _friendBusy = true);
    try {
      final api = ref.read(apiClientProvider);
      final friends = await api.getFriends();
      final incoming = await api.getIncomingFriendRequests();
      final outgoing = await api.getOutgoingFriendRequests();
      if (!mounted) return;
      setState(() {
        _friends = friends;
        _incomingFriendRequests = incoming;
        _outgoingFriendRequests = outgoing;
      });
    } catch (e) {
      _showError('Failed to load friends: $e');
    } finally {
      if (mounted) setState(() => _friendBusy = false);
    }
  }

  Future<void> _sendFriendRequest(String username) async {
    setState(() => _friendBusy = true);
    try {
      final api = ref.read(apiClientProvider);
      await api.sendFriendRequest(targetUsername: username);
      setState(() => _friendSearchResults = const []);
      await _loadFriends();
    } catch (e) {
      _showError('Failed to send request: $e');
      if (mounted) setState(() => _friendBusy = false);
    }
  }

  Future<void> _searchFriendUsers(String query) async {
    setState(() => _friendBusy = true);
    try {
      final api = ref.read(apiClientProvider);
      final users = await api.searchFriendUsers(query: query);
      if (!mounted) return;
      setState(() {
        _friendSearchResults = users;
      });
    } catch (e) {
      _showError('Failed to search users: $e');
    } finally {
      if (mounted) setState(() => _friendBusy = false);
    }
  }

  Future<void> _acceptFriendRequest(int requestId) async {
    setState(() => _friendBusy = true);
    try {
      final api = ref.read(apiClientProvider);
      await api.acceptFriendRequest(requestId: requestId);
      await _loadFriends();
    } catch (e) {
      _showError('Failed to accept request: $e');
      if (mounted) setState(() => _friendBusy = false);
    }
  }

  Future<void> _rejectFriendRequest(int requestId) async {
    setState(() => _friendBusy = true);
    try {
      final api = ref.read(apiClientProvider);
      await api.rejectFriendRequest(requestId: requestId);
      await _loadFriends();
    } catch (e) {
      _showError('Failed to reject request: $e');
      if (mounted) setState(() => _friendBusy = false);
    }
  }

  Future<void> _cancelOutgoingFriendRequest(int requestId) async {
    setState(() => _friendBusy = true);
    try {
      final api = ref.read(apiClientProvider);
      await api.cancelFriendRequest(requestId: requestId);
      await _loadFriends();
    } catch (e) {
      _showError('Failed to cancel request: $e');
      if (mounted) setState(() => _friendBusy = false);
    }
  }

  Future<void> _removeFriend(String friendUserId) async {
    setState(() => _friendBusy = true);
    try {
      final api = ref.read(apiClientProvider);
      await api.removeFriend(friendUserId: friendUserId);
      await _loadFriends();
    } catch (e) {
      _showError('Failed to remove friend: $e');
      if (mounted) setState(() => _friendBusy = false);
    }
  }

  void _openShop() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ShopScreen(
          isBusy: _purchaseBusy,
          message: _purchaseMessage,
          products: _shopProducts,
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
  void dispose() {
    _purchaseService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final runState = ref.watch(runSessionControllerProvider);
    final authState = ref.watch(authControllerProvider);
    final userName = authState.session?.user.displayName ?? authState.session?.user.username ?? 'User';

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
      ReportScreen(
        friends: _friends,
        incomingRequests: _incomingFriendRequests,
        outgoingRequests: _outgoingFriendRequests,
        searchResults: _friendSearchResults,
        isBusy: _friendBusy,
        onRefresh: _loadFriends,
        onSearchUsers: _searchFriendUsers,
        onSendRequest: _sendFriendRequest,
        onAcceptRequest: _acceptFriendRequest,
        onRejectRequest: _rejectFriendRequest,
        onCancelOutgoingRequest: _cancelOutgoingFriendRequest,
        onRemoveFriend: _removeFriend,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('RunPet - $userName'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout_current') {
                ref.read(authControllerProvider.notifier).logout();
              } else if (value == 'logout_all') {
                ref.read(authControllerProvider.notifier).logout(allSessions: true);
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'logout_current',
                child: Text('Logout this device'),
              ),
              PopupMenuItem(
                value: 'logout_all',
                child: Text('Logout all devices'),
              ),
            ],
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      body: IndexedStack(index: _tabIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (index) {
          setState(() => _tabIndex = index);
          if (index == 3) {
            _loadFriends();
          }
        },
        destinations: [
          const NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          const NavigationDestination(icon: Icon(Icons.directions_run), label: 'Running'),
          NavigationDestination(
            icon: PetAvatar(size: 26, mood: _pet?.petMood ?? 'happy', hatId: _pet?.equippedHatId),
            label: 'Pet',
          ),
          const NavigationDestination(icon: Icon(Icons.bar_chart_outlined), label: 'Report'),
        ],
      ),
    );
  }
}
