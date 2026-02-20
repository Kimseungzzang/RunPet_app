import 'package:flutter/material.dart';
import 'package:runpet_app/models/friend_models.dart';
import 'package:runpet_app/widgets/runpet_card.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({
    super.key,
    required this.friends,
    required this.incomingRequests,
    required this.isBusy,
    required this.onRefresh,
    required this.onSendRequest,
    required this.onAcceptRequest,
    required this.onRejectRequest,
    required this.onRemoveFriend,
  });

  final List<FriendModel> friends;
  final List<FriendRequestModel> incomingRequests;
  final bool isBusy;
  final Future<void> Function() onRefresh;
  final Future<void> Function(String username) onSendRequest;
  final Future<void> Function(int requestId) onAcceptRequest;
  final Future<void> Function(int requestId) onRejectRequest;
  final Future<void> Function(String friendUserId) onRemoveFriend;

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
                        if (username.isEmpty) return;
                        await widget.onSendRequest(username);
                        _friendUsernameController.clear();
                      },
                child: const Text('Send request'),
              ),
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
      ],
    );
  }
}
