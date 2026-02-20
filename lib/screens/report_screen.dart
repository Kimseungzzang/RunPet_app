import 'package:flutter/material.dart';
import 'package:runpet_app/models/friend_models.dart';
import 'package:runpet_app/widgets/runpet_card.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({
    super.key,
    required this.friends,
    required this.incomingRequests,
    required this.outgoingRequests,
    required this.searchResults,
    required this.blockedUsers,
    required this.activities,
    required this.isBusy,
    required this.onRefresh,
    required this.onSearchUsers,
    required this.onSendRequest,
    required this.onAcceptRequest,
    required this.onRejectRequest,
    required this.onCancelOutgoingRequest,
    required this.onRemoveFriend,
    required this.onBlockUser,
    required this.onUnblockUser,
  });

  final List<FriendModel> friends;
  final List<FriendRequestModel> incomingRequests;
  final List<FriendRequestModel> outgoingRequests;
  final List<FriendSearchUserModel> searchResults;
  final List<BlockedUserModel> blockedUsers;
  final List<FriendActivityModel> activities;
  final bool isBusy;
  final Future<void> Function() onRefresh;
  final Future<void> Function(String query) onSearchUsers;
  final Future<void> Function(String username) onSendRequest;
  final Future<void> Function(int requestId) onAcceptRequest;
  final Future<void> Function(int requestId) onRejectRequest;
  final Future<void> Function(int requestId) onCancelOutgoingRequest;
  final Future<void> Function(String friendUserId) onRemoveFriend;
  final Future<void> Function(String userId) onBlockUser;
  final Future<void> Function(String userId) onUnblockUser;

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _friendUsernameController = TextEditingController();

  @override
  void dispose() {
    _friendUsernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Text('Friends', style: Theme.of(context).textTheme.headlineSmall),
            const Spacer(),
            IconButton(
              onPressed: widget.isBusy ? null : () => widget.onRefresh(),
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        const SizedBox(height: 12),
        RunpetCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Friend activity feed', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              if (widget.activities.isEmpty) const Text('No recent friend runs'),
              for (final item in widget.activities)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${item.displayName} (@${item.username})', style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text('Run ${item.distanceKm.toStringAsFixed(2)}km · ${item.durationSec}s · ${item.calories} kcal'),
                    ],
                  ),
                ),
            ],
          ),
        ),
        RunpetCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add friend', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              TextField(
                controller: _friendUsernameController,
                decoration: const InputDecoration(
                  hintText: 'Enter username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: widget.isBusy
                    ? null
                    : () async {
                        final username = _friendUsernameController.text.trim();
                        if (username.length < 2) return;
                        await widget.onSearchUsers(username);
                      },
                child: const Text('Search users'),
              ),
              if (widget.searchResults.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text('Search result', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                for (final user in widget.searchResults)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Expanded(child: Text('${user.displayName} (@${user.username})')),
                        TextButton(
                          onPressed: widget.isBusy
                              ? null
                              : () async {
                                  await widget.onSendRequest(user.username);
                                  _friendUsernameController.clear();
                                },
                          child: const Text('Add'),
                        ),
                      ],
                    ),
                  ),
              ],
            ],
          ),
        ),
        RunpetCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Incoming requests', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              if (widget.incomingRequests.isEmpty) const Text('No pending requests'),
              for (final req in widget.incomingRequests)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(child: Text(req.fromDisplayName)),
                      TextButton(
                        onPressed: widget.isBusy ? null : () => widget.onAcceptRequest(req.requestId),
                        child: const Text('Accept'),
                      ),
                      TextButton(
                        onPressed: widget.isBusy ? null : () => widget.onRejectRequest(req.requestId),
                        child: const Text('Reject'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        RunpetCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Outgoing requests', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              if (widget.outgoingRequests.isEmpty) const Text('No outgoing requests'),
              for (final req in widget.outgoingRequests)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(child: Text('${req.toUsername} (pending)')),
                      TextButton(
                        onPressed: widget.isBusy ? null : () => widget.onCancelOutgoingRequest(req.requestId),
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        RunpetCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Friend list', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              if (widget.friends.isEmpty) const Text('No friends yet'),
              for (final friend in widget.friends)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text('${friend.displayName} (@${friend.username})'),
                      ),
                      IconButton(
                        tooltip: 'Block user',
                        onPressed: widget.isBusy ? null : () => widget.onBlockUser(friend.userId),
                        icon: const Icon(Icons.block_outlined),
                      ),
                      IconButton(
                        tooltip: 'Remove friend',
                        onPressed: widget.isBusy ? null : () => widget.onRemoveFriend(friend.userId),
                        icon: const Icon(Icons.person_remove_outlined),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        RunpetCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Blocked users', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              if (widget.blockedUsers.isEmpty) const Text('No blocked users'),
              for (final blocked in widget.blockedUsers)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(child: Text('${blocked.displayName} (@${blocked.username})')),
                      TextButton(
                        onPressed: widget.isBusy ? null : () => widget.onUnblockUser(blocked.userId),
                        child: const Text('Unblock'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
